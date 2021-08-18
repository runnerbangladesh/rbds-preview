module ModalGateway = {
  @module("react-images") @react.component
  external make: (~children: React.element) => React.element = "ModalGateway"
}

module Modal = {
  @module("react-images") @react.component
  external make: (~children: React.element, ~onClose: unit => unit) => React.element = "Modal"
}

module Carousel = {
  type source = {
    regular: string,
    fullscreen: string,
    thumbnail: string,
  }
  type viewProps = {
    source: source,
    caption: string,
    alt: string,
  }

  type styles = {footerCaption: unit => ReactDOMStyle.t}

  @module("react-images") @react.component
  external make: (
    // ~children: React.element=?,
    ~currentIndex: int=?,
    ~modalProps: 'props=?,
    ~styles: styles=?,
    ~views: array<viewProps>,
  ) => React.element = "default"
}
