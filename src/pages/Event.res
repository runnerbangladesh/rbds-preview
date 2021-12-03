open React
open Client
open ReasonDateFns
open ReactIcons
open Extensions

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
  let {data, isValidating, loadingSlow} = Hooks.useData(id, fetchEvent)

  switch data {
  | None => <LoadingComponent loadingSlow={loadingSlow} />
  | Some(data) =>
    switch data {
    | Error(err) => <ErrorComponent error={err} />
    | Ok(data) => {
        let entry = data.entry["fields"]
        document["title"] = `Preview ― ` ++ entry.title
        let parsedStartDate = Js.Date.fromString(entry.eventStartDate)
        let parsedEndDate = entry.eventEndDate->Belt.Option.map(Js.Date.fromString)

        <>
          {isValidating ? <OverlaySpinner /> : null}
          <div className="p-4 mx-52 flex flex-col flex-auto">
            {switch entry.images {
            | Some(images) =>
              <img
                src={images[0]["fields"]["file"]["url"] ++ "?h=400&fm=webp&q=70"}
                className="max-w-full object-cover mb-4 rounded-lg shadow-lg"
              />
            | _ => null
            }}
            <h1 className="text-accent text-4xl leading-tight font-medium">
              {entry.title->string}
            </h1>
            <IconContext.Provider
              value={
                color: "var(--accent-color)",
                style: ReactDOMStyle.make(~marginRight="8px", ()),
              }>
              <span className="text-md leading-tight font-light text-xl e-meta">
                <span> {parsedStartDate->formatDate->string} </span>
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
            <div className="pt-3 text-xl leading-normal">
              {ContentfulReact.documentToReactComponents(entry.description)}
            </div>
          </div>
        </>
      }
    }
  }
}
