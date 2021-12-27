%%raw(`import "typeface-fira-sans"`)
%%raw(`import "typeface-roboto-slab"`)
%%raw(`import "./index.css"`)

switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(<React.StrictMode> <App /> </React.StrictMode>, root)
| None => "React mount root missing!"->Js.Console.error
}
