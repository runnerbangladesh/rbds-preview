type swrReturn<'data, 'error> = {data: option<'data>, error: option<Js.Exn.t>}

@module("swr")
external useSWR: ('arg, 'arg => Promise.t<'return>, 'config) => swrReturn<'return, 'error> =
  "default"

module SWRConfig = {
  @module("swr") @react.component
  external make: (~value: 'obj, ~children: React.element) => React.element = "SWRConfig"
}
