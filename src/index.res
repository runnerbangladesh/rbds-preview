%%raw(`import "typeface-fira-sans"`)
%%raw(`import "typeface-roboto-slab"`)
%%raw(`import "./index.css"`)

switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(<React.StrictMode> <App /> </React.StrictMode>, root)
| None => Js.Console.error("React mount root missing!")
}
