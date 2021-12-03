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
