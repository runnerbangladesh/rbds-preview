@module("react-masonry-css") @react.component
external make: (
  ~children: React.element,
  ~breakpointCols: {..}=?,
  ~className: string=?,
  ~columnClassName: string=?,
) => React.element = "default"
