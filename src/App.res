@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  <Swr.SwrConfigProvider
    value={Swr.swrConfiguration(
      ~shouldRetryOnError=true,
      ~errorRetryCount=2,
      ~loadingTimeout=4000,
      ~refreshInterval=%raw(`import.meta.env.PROD ? 10000 : undefined`),
      (),
    )}>
    {switch url.path {
    | list{"activity", id} => <Activity id />
    | list{"event", id} => <Event id />
    | _ => <Home />
    }}
  </Swr.SwrConfigProvider>
}
