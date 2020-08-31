import React from "react";
import { BrowserRouter as Router, Route } from "react-router-dom";
import { Switch } from "react-router";
import Activity from "./pages/activity";
import Home from "./pages/home";
import Event from "./pages/event";
import { SWRConfig } from "swr";

function App() {
  return (
    <SWRConfig
      value={{
        refreshInterval:
          process.env.NODE_ENV === "production" ? 10000 : undefined,
        shouldRetryOnError: false,
        errorRetryCount: 2,
        loadingTimeout: 3000,
      }}
    >
      <Router>
        <Switch>
          <Route exact path="/activity/:id">
            <Activity />
          </Route>
          <Route exact path="/event/:id">
            <Event />
          </Route>
          <Route path="*" exact>
            <Home />
          </Route>
        </Switch>
      </Router>
    </SWRConfig>
  );
}

export default App;
