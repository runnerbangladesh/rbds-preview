type errors = InvalidContentType | EntryNotFound | Other(string)

// type routerParams = {id: string}
// @module("wouter") external useRoute: string => (bool, routerParams) = "useRoute"

@module("marked") external marked: string => string = "default"

@val external document: 'doc = "document"
