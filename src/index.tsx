import "bootstrap/scss/bootstrap.scss";
import React from "react";
import { render } from "react-dom";
import "typeface-fira-sans";
import "typeface-roboto-slab";
import App from "./App";
import "./index.scss";
import * as serviceWorker from "./serviceWorker";

render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById("root")!
);

serviceWorker.register();
