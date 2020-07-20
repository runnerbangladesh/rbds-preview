import React, { useState, Fragment } from "react";
import fetcher from "../contentful/client";
import { useParams } from "react-router";
import "./activity.scss";
import { Container, Row, Col } from "react-bootstrap";
import marked from "marked";
import Masonry from "react-masonry-css";
import dateFormat from "dateformat";
import Carousel, { ModalGateway, Modal } from "react-images";
import useSWR from "swr";
import Image from "react-image-fade-in";

const Activity = () => {
  const { id } = useParams();
  const [loadingSlow, setLoadingSlow] = useState(false);
  const [modalIsOpen, setModalIsOpen] = useState(false);
  const [currentImage, setCurrentImage] = useState(0);
  const { data, error } = useSWR(id, fetcher, {
    refreshInterval: process.env.NODE_ENV === "production" ? 10000 : undefined,
    shouldRetryOnError: false,
    errorRetryCount: 2,
    loadingTimeout: 3000,
    onLoadingSlow: () => setLoadingSlow(true),
  });

  const openLightbox = (index) => {
    setCurrentImage(index);
    setModalIsOpen(true);
  };

  if (!data) {
    if (error) {
      console.error(error);
      document.title = ":-(";
      return (
        <div className="error">
          Four-oh-four!
          <br />
          <small className="muted">{error.message}</small>
        </div>
      );
    }
    document.title = "Loading preview...";
    return (
      <div className="loading">
        Loading...
        <br />
        {loadingSlow && (
          <small className="muted">This is taking too long.</small>
        )}
      </div>
    );
  }

  document.title = "Preview — " + data.entry.fields.title;
  const parsedBody = marked(data.entry.fields.articleBody ?? "");
  const parsedDate = new Date(data.entry.fields.date);

  return (
    <Fragment>
      <header className="masthead mb-md-2">
        <Container className="container">
          <Row className="row">
            <Col lg={8} md={10} className="mx-auto">
              <div className="post-heading">
                <h1>{data.entry.fields.title}</h1>
                <span className="meta">
                  {dateFormat(parsedDate, "d mmmm yyyy")}
                </span>
              </div>
            </Col>
          </Row>
        </Container>
      </header>

      <article>
        {data.images && (
          <Masonry
            breakpointCols={{ default: 3, 1100: 3, 700: 2, 500: 1 }}
            className="my-masonry-grid px-md-5 pt-md-5 p-3"
            columnClassName="my-masonry-grid_column"
          >
            {data.images.map((image, index) => (
              <div
                key={index}
                role="button"
                onClick={() => openLightbox(index)}
                onKeyPress={(e) => e.key === "Enter" && openLightbox(index)}
                tabIndex={0}
                className="gallery-image-container shadow"
              >
                <Image
                  className="gallery-image rounded fit-cover"
                  src={image.url + "?w=800&fm=webp&q=70"}
                  alt={image.description}
                  loading="lazy"
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
        </Container>
      </article>
      {data.images && (
        <ModalGateway>
          {modalIsOpen ? (
            <Modal onClose={() => setModalIsOpen(false)}>
              <Carousel
                views={data.images.map((img) => ({
                  src: img.url + "?w=800&fm=webp&q=70",
                  caption: img.description,
                  alt: img.description,
                }))}
                currentIndex={currentImage}
                modalProps={{ allowFullscreen: false }}
                styles={{
                  footerCaption: () => ({
                    fontSize: "16",
                  }),
                }}
              ></Carousel>
            </Modal>
          ) : null}
        </ModalGateway>
      )}
    </Fragment>
  );
};

export default Activity;
