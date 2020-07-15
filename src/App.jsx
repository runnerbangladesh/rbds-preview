import React from "react";
import { BrowserRouter as Router, Route } from "react-router-dom";
import { Switch } from "react-router";
import Activity from "./pages/activity";
import Home from "./pages/home";

function App() {
  return (
    <Router>
      <Switch>
        <Route exact path="/activity/:id">
          <Activity />
        </Route>
        <Route path="*" exact>
          <Home />
        </Route>
      </Switch>
    </Router>
  );
}

export default App;
