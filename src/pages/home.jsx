const phrases = [
  "Nothing to see here.",
  "Uh-doy!",
  "You should be somewhere else.",
  "This must be a mistake.",
  "Toit barry!",
  "Oopsie doopsie!",
];

const Home = () => {
  return (
    <div
      style={{
        padding: "3em",
      }}
    >
      <h1>{phrases[Math.floor(Math.random() * phrases.length)]}</h1>
      <a href="//app.contentful.com">Click here</a> to access Contentful.
    </div>
  );
};

export default Home;
