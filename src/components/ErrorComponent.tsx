const ErrorComponent = ({ error }: { error: Error }) => {
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
