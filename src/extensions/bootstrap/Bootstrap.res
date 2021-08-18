module Container = {
  @module("react-bootstrap/Container") @react.component
  external make: (~children: React.element) => React.element = "default"
}

module Row = {
  @module("react-bootstrap/Row") @react.component
  external make: (~children: React.element) => React.element = "default"
}

module Col = {
  @module("react-bootstrap/Col") @react.component
  external make: (
    ~children: React.element=?,
    ~lg: int=?,
    ~md: int=?,
    ~className: string=?,
    ~dangerouslySetInnerHTML: {"__html": string}=?,
  ) => React.element = "default"
}
