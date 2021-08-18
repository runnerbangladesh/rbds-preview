// import React from "react";
// import { render } from "react-dom";
%%raw(`import "typeface-fira-sans"`)
%%raw(`import "typeface-roboto-slab"`)
%%raw(`import "bootstrap/scss/bootstrap.scss"`)
%%raw(`import "./index.scss"`)

// render(
//   <React.StrictMode>
//     <App />
//   </React.StrictMode>,
//   document.getElementById("root")!
// );

// serviceWorker.register();

switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(<React.StrictMode> <App /> </React.StrictMode>, root)
| None => Js.Console.error("React mount root missing!")
}
