import { format } from "date-fns/fp";
import marked from "marked";
import { Fragment, useState } from "react";
import Col from "react-bootstrap/Col";
import Container from "react-bootstrap/Container";
import Row from "react-bootstrap/Row";
import Carousel, { Modal, ModalGateway } from "react-images";
import Masonry from "react-masonry-css";
import useSWR from "swr";
import { useRoute } from "wouter";
import ErrorComponent from "../components/ErrorComponent";
import LoadingComponent from "../components/LoadingComponent";
import { fetchActivity } from "../contentful/client";
import "./activity.scss";

const Activity = () => {
  const [, params] = useRoute("/activity/:id");
  const [loadingSlow, setLoadingSlow] = useState(false);
  const [modalIsOpen, setModalIsOpen] = useState(false);
  const [currentImage, setCurrentImage] = useState(0);
  const { data, error } = useSWR(params.id, fetchActivity, {
    onLoadingSlow: () => setLoadingSlow(true),
  });

  const openLightbox = (index: number) => {
    setCurrentImage(index);
    setModalIsOpen(true);
  };

  if (!data) {
    if (error) {
      console.error(error);
      return <ErrorComponent error={error} />;
    }
    return <LoadingComponent loadingSlow={loadingSlow} />;
  }

  const entry = data.entry.fields;

  document.title = "Preview — " + entry.title;
  const parsedBody = marked(entry.articleBody ?? "");
  const parsedDate = new Date(entry.date);

  return (
    <Fragment>
      <header className="masthead mb-md-2">
        <Container>
          <Row>
            <Col lg={8} md={10} className="mx-auto">
              <div className="post-heading">
                <h1>{entry.title}</h1>
                <span className="meta">
                  {format("d MMMM yyyy", parsedDate)}
                </span>
              </div>
            </Col>
          </Row>
        </Container>
      </header>

      <article>
        {data.images && (
          <Masonry
            breakpointCols={
              data.images.length === 1
                ? { default: 1 }
                : data.images.length <= 6 && data.images.length % 2 === 0
                ? { default: 2, 640: 1 }
                : { default: 4, 1440: 3, 1280: 2, 640: 1 }
            }
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
                <img
                  className="gallery-image rounded fit-cover"
                  src={image.url + "?w=1200&fm=webp&q=70"}
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
      {data.images?.length > 0 && (
        <ModalGateway>
          {modalIsOpen ? (
            <Modal onClose={() => setModalIsOpen(false)}>
              <Carousel
                views={data.images.map((img) => ({
                  source: {
                    regular: img.url + "?w=800&fm=webp&q=70",
                    fullscreen: img.url,
                    thumbnail: img.url + "?w=250&fm=webp&q=50",
                  },
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
