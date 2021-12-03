@module("react-masonry-css") @react.component
external make: (
  ~children: React.element,
  ~breakpointCols: Js.Dict.t<int> =?,
  ~className: string=?,
  ~columnClassName: string=?,
) => React.element = "default"
