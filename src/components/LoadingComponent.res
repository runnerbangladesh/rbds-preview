open React

@react.component
let make = (~loadingSlow=false) => {
  <div className="p-6">
    <h1>{"Loading..."->string}</h1>
    <br />
    {loadingSlow ? <small className="muted"> {"This is taking too long."->string} </small> : null}
  </div>
}
