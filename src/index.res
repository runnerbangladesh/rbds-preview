%%raw(`import "typeface-fira-sans"`)
%%raw(`import "typeface-roboto-slab"`)
%%raw(`import "bootstrap/scss/bootstrap.scss"`)
%%raw(`import "./index.scss"`)

switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(<React.StrictMode> <App /> </React.StrictMode>, root)
| None => Js.Console.error("React mount root missing!")
}
