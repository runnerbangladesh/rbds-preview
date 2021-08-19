open React
open Extensions

@react.component
let make = (~error: errors) => {
  document["title"] = `Preview ― An error occurred`
  <div className="error">
    {"Four-oh-four!"->string}
    <br />
    <small className="muted">
      {(switch error {
      | InvalidContentType => "Content type is invalid."
      | EntryNotFound => "Entry not found."
      | Other(msg) => msg
      } ++ " Contact administrator if error persists.")->string}
    </small>
  </div>
}
