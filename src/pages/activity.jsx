import React, { useState, useEffect, Fragment } from "react";
import client, { getImages } from "../contentful/client";
import { useParams } from "react-router";
import "./activity.scss";
import { Container, Row, Col } from "react-bootstrap";
import marked from "marked";
import Masonry from "react-masonry-css";
import dateFormat from "dateformat";

const Activity = () => {
  const { id } = useParams();
  const [entry, setEntry] = useState();
  const [images, setImages] = useState();
  const [timeup, setTimeup] = useState(false);

  useEffect(() => {
    async function getActivity() {
      setEntry(await client.getEntry(id));
      setImages(await getImages(id));
    }
    getActivity();
    setTimeout(() => {
      setTimeup(true);
    }, 5000);
  }, [id]);

  if (!entry && !images) {
    return (
      <div
        style={{
          padding: "2em",
          fontSize: "20pt",
        }}
      >
        Loading...
        <br />
        {timeup && (
          <small>
            Taking too long? Check your connection and refresh, or contact the
            site administrator.
          </small>
        )}
      </div>
    );
  }
  document.title = "Preview — " + entry.fields.title;
  const parsedBody = marked(entry.fields.articleBody ?? "");
  const parsedDate = new Date(entry.fields.date);

  return (
    <Fragment>
      <header className="masthead mb-md-2">
        <Container className="container">
          <Row className="row">
            <Col lg={8} md={10} className="mx-auto">
              <div className="post-heading">
                <h1>{entry.fields.title}</h1>
                <span className="meta">
                  {dateFormat(parsedDate, "d mmmm yyyy")}
                </span>
              </div>
            </Col>
          </Row>
        </Container>
      </header>

      <article>
        {images && (
          <Masonry
            breakpointCols={{ default: 3, 1100: 3, 700: 2, 500: 1 }}
            className="my-masonry-grid px-md-5 pt-md-5 p-3"
            columnClassName="my-masonry-grid_column"
          >
            {images.map((image, index) => (
              <div
                key={index}
                role="button"
                //   onClick={() => /*openLightbox(index)*/}
                //   onKeyPress={e => e.key === "Enter" && openLightbox(index)}
                tabIndex={0}
                className="gallery-image-container shadow"
              >
                <img
                  className="gallery-image rounded fit-cover"
                  src={image.url}
                  alt={image.description}
                />
                <div className="gallery-image-container-middle">
                  <div className="gallery-image-container-text">
                    {image.description}
                  </div>
                </div>
              </div>
            ))}
          </Masonry>
        )}
        <Container>
          <Row>
            <Col
              className="mx-auto px-md-7 px-4 article"
              dangerouslySetInnerHTML={{
                __html: parsedBody,
              }}
            />
          </Row>
          <Row>
            <Col className="mt-4">
              {/* <a href="/">&larr; Back to Activities</a> */}
            </Col>
            <Col className="mt-4 text-right">
              {/* <ShareComponent
                excerpt={post.articleBody.childMarkdownRemark.excerpt}
                slug={post.slug}
                page="activities"
                title={post.title}
              /> */}
            </Col>
          </Row>
        </Container>
      </article>
    </Fragment>
  );
};

export default Activity;
