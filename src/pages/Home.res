open React

let phrases = list{
  "Nothing to see here.",
  "Uh-doy!",
  "You should be somewhere else.",
  "This must be a mistake.",
  "Toit barry!",
}

@react.component
let make = () => {
  let random_index = Js.Math.floor_int(
    Js.Math.random_int(0, Js.List.length(phrases))->Js.Int.toFloat,
  )

  <div style={ReactDOMStyle.make(~padding="3em", ())}>
    <h1>
      {switch Js.List.nth(phrases, random_index) {
      | Some(phrase) => phrase->string
      | _ => null
      }}
    </h1>
    <a href="//app.contentful.com"> {"Click here"->string} </a>
    {" to access Contentful"->string}
  </div>
}
