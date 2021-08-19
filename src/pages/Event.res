open React
open Client
open ReasonDateFns
open ReactIcons
open SWR
open Extensions

%%raw(`import "./event.scss"`)

let formatDate = DateFns.format("cccc, d MMMM yyyy")
let formatTime = DateFns.format("p")

let renderDates = (startDate, endDate) => {
  switch endDate {
  | None => <span> {formatDate(startDate)->string} </span>
  | Some(endDate) if endDate->Js.Date.getDay != startDate->Js.Date.getDay =>
    <span> {(formatDate(startDate) ++ " to " ++ formatDate(endDate))->string} </span>
  | _ => <span />
  }
}

let renderTimes = (startDate, endDate) => {
  switch endDate {
  | None => <span> {formatTime(startDate)->string} </span>
  | Some(endDate) =>
    <span> {(formatTime(startDate) ++ " to " ++ formatTime(endDate))->string} </span>
  }
}

@react.component
let make = (~id: string) => {
  let (loadingSlow, setLoadingSlow) = useState(() => false)
  let {data, error} = useSWR(
    id,
    fetchEvent,
    {
      "onLoadingSlow": () => setLoadingSlow(_ => true),
    },
  )

  switch (data, error) {
  | (None, None) => <LoadingComponent loadingSlow={loadingSlow} />
  | (None, Some(err)) =>
    Js.Console.error(error)
    <ErrorComponent error={Other(Js.Exn.message(err)->Belt.Option.getWithDefault("Error!"))} />
  | (Some(data: result<contentData<eventEntryFields>, errors>), None) =>
    switch data {
    | Error(err) => <ErrorComponent error={err} />
    | Ok(data) => {
        let entry = data.entry.fields
        document["title"] = `Preview ― ` ++ entry.title
        let parsedStartDate = Js.Date.fromString(entry.eventStartDate)
        let parsedEndDate = entry.eventEndDate->Belt.Option.map(Js.Date.fromString)

        <>
          <div className="e-main">
            {switch entry.images {
            | Some(images) =>
              <img
                src={images[0]["fields"]["file"]["url"] ++ "?h=400&fm=webp&q=70"}
                className="e-big-image"
              />
            | _ => null
            }}
            <h1 className="e-heading"> {entry.title->string} </h1>
            <IconContext.Provider
              value={
                color: "var(--accent-color)",
                style: ReactDOMStyle.make(~marginRight="8px", ()),
              }>
              <span className="e-meta">
                <span> {renderDates(parsedStartDate, parsedEndDate)} </span>
                {switch entry.eventVenue {
                | Some(venue) => <span> <Fa.FaMapMarkerAlt /> {venue->string} </span>
                | None => null
                }}
                <span> <Fa.FaClock /> {renderTimes(parsedStartDate, parsedEndDate)} </span>
                <span>
                  <a href={entry.facebookLink} rel="noopener noreferrer nofollow" target="_blank">
                    <Fa.FaFacebook /> {" View on Facebook"->string}
                  </a>
                </span>
              </span>
            </IconContext.Provider>
            <div className="e-body">
              {Contentful.documentToReactComponents(entry.description)}
            </div>
          </div>
        </>
      }
    }
  | (_, _) => <div> {string("What?")} </div>
  }
}
