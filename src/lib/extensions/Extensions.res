type exns = String(string) | JsError(Js.Exn.t)
type errors = InvalidContentType | EntryNotFound | Other(exns)

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
  type useData<'data, 'error> = {
    data: option<'data>,
    error: 'error,
    isValidating: bool,
    loadingSlow: bool,
  }

  let useData = (id, fetcher) => {
    let (loadingSlow, setLoadingSlow) = React.Uncurried.useState(_ => false)
    let {data, error, isValidating} = Swr.useSWR_config(
      id,
      fetcher,
      Swr.swrConfiguration(~onLoadingSlow=(_, _) => {
        setLoadingSlow(._ => true)
      }, ()),
    )
    {data: data, error: error, isValidating: isValidating, loadingSlow: loadingSlow}
  }
}
