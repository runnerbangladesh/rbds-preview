open React
open Client
open ReactIcons
open Extensions

let makeFormatter = Intl.DateTimeFormat.make(~locales=["en-IN"], ...)

let dateFormatter = makeFormatter(~options={dateStyle: #medium})
let timeFormatter = makeFormatter(~options={timeStyle: #short})

let formatDate = Intl.DateTimeFormat.format(dateFormatter, ...)
let formatTime = Intl.DateTimeFormat.format(timeFormatter, ...)

let renderDates = (startDate, endDate) => {
  open Date
  switch endDate {
  | None => <span> {formatDate(startDate)->string} </span>
  | Some(endDate) if endDate->getDay != startDate->getDay =>
    <span> {(formatDate(startDate) ++ " to " ++ formatDate(endDate))->string} </span>
  | _ => <span />
  }
}

let renderTimes = (startDate, endDate) => {
  let formattedStart = formatTime(startDate)
  switch endDate {
  | None => <span> {formattedStart->string} </span>
  | Some(endDate) =>
    if endDate->Date.getDay != startDate->Date.getDay {
      <span> {(formattedStart ++ " to " ++ formatTime(endDate))->string} </span>
    } else {
      <span> {formattedStart->string} </span>
    }
  }
}

let renderEntry = entry => {
  let parsedStartDate = Date.fromString(entry.eventStartDate)
  let parsedEndDate = entry.eventEndDate->Option.map(Date.fromString)
  <div className="p-4 pt-16 md:mx-52 flex flex-col flex-auto">
    {switch entry.images {
    | Some([image]) =>
      <img
        src={image["fields"]["file"]["url"] ++ "?h=400&fm=webp&q=70"}
        className="max-w-full object-cover mb-4 rounded-lg shadow-lg"
      />
    | _ => React.null
    }}
    <h1 className="text-accent text-4xl leading-tight font-medium"> {entry.title->string} </h1>
    <IconContext.Provider
      value={
        color: "var(--accent-color)",
        style: ReactDOMStyle.make(~marginRight="8px", ()),
      }>
      <span className="text-md leading-tight font-light text-xl e-meta">
        <span> {parsedStartDate->formatDate->string} </span>
        <span> {renderDates(parsedStartDate, parsedEndDate)} </span>
        {switch entry.eventVenue {
        | Some(venue) =>
          <span>
            <Fi.FaMapPin />
            {venue->string}
          </span>
        | None => React.null
        }}
        <span>
          <Fi.FiClock />
          {renderTimes(parsedStartDate, parsedEndDate)}
        </span>
        <span>
          <a href={entry.facebookLink} rel="noopener noreferrer nofollow" target="_blank">
            <Fi.FiFacebook />
            {" View on Facebook"->string}
          </a>
        </span>
      </span>
    </IconContext.Provider>
    <div className="pt-3 text-xl leading-normal">
      {ContentfulReact.documentToReactComponents(entry.description)}
    </div>
  </div>
}

@react.component
let make = (~id: string) => {
  let {state, isValidating, loadingSlow, mutate} = Hooks.useData(id, fetchEvent)

  let status = (slug, isError) =>
    <Status
      title="Event Preview"
      isValidating={isValidating}
      canonicalUrl={"https://events.runnerbangladesh.org/archives/" ++ slug}
      isError={isError}
      onRefresh={() => {
        mutate(data => Obj.magic(data), None)->ignore
      }}
    />

  switch state {
  | Loading => <LoadingComponent loadingSlow={loadingSlow} />
  | Resolved(result) =>
    let entry = result->These.mapThisU(data => data.entry["fields"])
    switch entry {
    | That(err) => <ErrorComponent error={JsError(err)} />
    | This(entry) => {
        Extensions.document["title"] = `Preview ― ` ++ entry.title
        <>
          {status(entry.slug, false)}
          {renderEntry(entry)}
        </>
      }
    | These(entry, _) => {
        Extensions.document["title"] = `Trouble loading preview ― ` ++ entry.title
        <>
          {status(entry.slug, true)}
          {renderEntry(entry)}
        </>
      }
    }
  }
}
