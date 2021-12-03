open React
open Extensions

@react.component
let make = (~error: errors) => {
  document["title"] = `Preview ― An error occurred`
  <div className="p-6">
    <h5> {"Four-oh-four!"->string} </h5>
    <p className="leading-tight">
      <small className="muted">
        {switch error {
        | InvalidContentType => "Content type is invalid."
        | EntryNotFound => "Entry not found."
        | Other(String(msg)) => msg
        | Other(JsError(exn)) =>
          switch Js.Exn.message(exn) {
          | Some(msg) => msg
          | None => "Unknown error occurred."
          }
        }->string}
        <br />
        {"Contact administrator if error persists."->string}
      </small>
    </p>
  </div>
}
