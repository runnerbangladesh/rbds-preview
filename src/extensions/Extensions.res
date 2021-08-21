type exns = String(string) | JsError(Js.Exn.t)
type errors = InvalidContentType | EntryNotFound | Other(exns)

// type routerParams = {id: string}
// @module("wouter") external useRoute: string => (bool, routerParams) = "useRoute"

@module("marked") external marked: string => string = "default"

@val external document: 'doc = "document"
