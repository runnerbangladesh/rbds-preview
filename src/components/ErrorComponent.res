open React
open Extensions

@react.component
let make = (~error: exn) => {
  Extensions.document["title"] = `Preview ― An error occurred`

  <div className="p-6">
    <h5> {"Four-oh-four!"->string} </h5>
    <p className="leading-tight">
      <small className="muted">
        {switch error {
        | InvalidContentType => "Content type is invalid."
        | EntryNotFound => "Entry not found."
        | Exn.Error(exn) =>
          switch Exn.message(exn) {
          | Some(msg) => msg
          | None => "Cannot determine error type."
          }
        | _ => "Unknown error encountered."
        }->string}
        <br />
        {"Contact administrator if error persists."->string}
      </small>
    </p>
  </div>
}
