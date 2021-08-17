import { Route } from "wouter";
import Activity from "./pages/activity";
import Home from "./pages/home";
import Event from "./pages/event";
import { SWRConfig } from "swr";

function App() {
  return (
    <SWRConfig
      value={{
        refreshInterval: import.meta.env.PROD ? 10000 : undefined,
        shouldRetryOnError: false,
        errorRetryCount: 2,
        loadingTimeout: 3000,
      }}
    >
      <Route path="/activity/:id">
        <Activity />
      </Route>
      <Route path="/event/:id">
        <Event />
      </Route>
      <Route>
        <Home />
      </Route>
    </SWRConfig>
  );
}

export default App;
