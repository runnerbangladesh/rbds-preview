open React

let phrases = list{
  "Nothing to see here.",
  "Haste Ye Back!",
  "Osti!",
  "You should be somewhere else.",
  "This must be a mistake.",
  "Toit barry!",
}

@react.component
let make = () => {
  let random_index = Extensions.getRandomInt(phrases->List.length->Int.toFloat)
  <div className="p-6">
    <h1>
      {switch List.get(phrases, random_index) {
      | Some(phrase) => phrase->string
      | _ => React.null
      }}
    </h1>
    <a href="//app.contentful.com"> {"Click here"->string} </a>
    {" to access Contentful"->string}
  </div>
}
