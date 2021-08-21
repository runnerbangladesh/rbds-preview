@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  <Swr.SwrConfig
    config={Swr.Options.make(
      ~shouldRetryOnError=true,
      ~errorRetryCount=2,
      ~loadingTimeout=3000,
      ~refreshInterval=%raw(`import.meta.env.PROD ? 10000 : undefined`),
      (),
    )}>
    {switch url.path {
    | list{"activity", id} => <Activity id />
    | list{"event", id} => <Event id />
    | _ => <Home />
    }}
  </Swr.SwrConfig>
}
