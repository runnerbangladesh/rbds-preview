const LoadingComponent = ({ loadingSlow = false }) => {
  document.title = "Loading preview...";
  return (
    <div className="loading">
      Loading...
      <br />
      {loadingSlow && <small className="muted">This is taking too long.</small>}
    </div>
  );
};

export default LoadingComponent;
