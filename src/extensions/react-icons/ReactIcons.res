type value = {
  color: string,
  style: ReactDOMStyle.t,
}
module IconContext = {
  @module("react-icons")
  external context: React.Context.t<value> = "IconContext"

  module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value, ~children) => {
      React.createElement(provider, {"value": value, "children": children})
    }
  }
}

module Fa = {
  module FaMapMarkerAlt = {
    @module("react-icons/fa") @react.component
    external make: unit => React.element = "FaMapMarkerAlt"
  }
  module FaClock = {
    @module("react-icons/fa") @react.component
    external make: unit => React.element = "FaClock"
  }
  module FaFacebook = {
    @module("react-icons/fa") @react.component
    external make: unit => React.element = "FaFacebook"
  }
}
