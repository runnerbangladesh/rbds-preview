import React from "react";

const ErrorComponent = ({ error }) => {
  document.title = ":-(";
  return (
    <div className="error">
      Four-oh-four!
      <br />
      <small className="muted">{error.message}</small>
    </div>
  );
};

export default ErrorComponent;
