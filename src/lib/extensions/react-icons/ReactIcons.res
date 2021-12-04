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

module Fi = {
  module FaMapPin = {
    @module("react-icons/fi") @react.component
    external make: unit => React.element = "FiMapPin"
  }
  module FiClock = {
    @module("react-icons/fi") @react.component
    external make: unit => React.element = "FiClock"
  }
  module FiFacebook = {
    @module("react-icons/fi") @react.component
    external make: unit => React.element = "FiFacebook"
  }
}
