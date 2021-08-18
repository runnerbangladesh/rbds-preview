open SWR

@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  <SWRConfig
    value={
      "refreshInterval": %raw(`import.meta.env.PROD ? 10000 : undefined`),
      "shouldRetryOnError": false,
      "errorRetryCount": 2,
      "loadingTimeout": 3000,
    }>
    {switch url.path {
    | list{"activity", id} => <Activity id />
    | list{"event", id} => <Event id />
    | _ => <Home />
    }}
  </SWRConfig>
}
