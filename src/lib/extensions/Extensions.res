open These

exception InvalidContentType
exception EntryNotFound
exception JsError(Exn.t)

type asyncStatus<'a> = Loading | Resolved('a)

module Marked = {
  type t
  @module("marked") external marked: t = "marked"
  @send external parse: (t, string) => string = "parse"
}

module ContentfulReact = {
  @module("@contentful/rich-text-react-renderer")
  external documentToReactComponents: 'data => React.element = "documentToReactComponents"
}

@val external document: 'doc = "document"

module Hooks = {
  type useData<'data> = {
    state: asyncStatus<These.t<'data, Exn.t>>,
    isValidating: bool,
    loadingSlow: bool,
    mutate: SwrCommon.keyedMutator<'data>,
  }

  let useData = (id, fetcher) => {
    let (loadingSlow, setLoadingSlow) = React.Uncurried.useState(_ => false)
    let {data, error, isValidating, mutate} = Swr.useSWR_config(
      id,
      fetcher,
      {onLoadingSlow: (_, _) => {setLoadingSlow(_ => true)}},
    )

    let state = switch (data, error) {
    | (None, None) => Loading
    | (Some(data), None) => Resolved(This(data))
    | (None, Some(error)) => Resolved(That(error))
    | (Some(data), Some(error)) => Resolved(These(data, error))
    }
    {state, isValidating, loadingSlow, mutate}
  }
}

let getRandomInt = max => {
  Math.floor(Math.random() ** max)->Int.fromFloat
}
