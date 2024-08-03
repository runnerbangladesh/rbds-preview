%%raw(`import "@fontsource/fira-sans/latin-400.css"`)
%%raw(`import "@fontsource/roboto-slab/latin-400.css"`)
%%raw(`import "./index.css"`)

open ReactDOM

switch querySelector("#root") {
| Some(el) => Client.createRoot(el)->Client.Root.render(
    <React.StrictMode>
      <App />
    </React.StrictMode>,
  )
| None => "React mount root missing!"->Console.error
}
