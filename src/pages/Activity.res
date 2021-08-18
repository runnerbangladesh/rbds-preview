open React
open Bootstrap
open Client
open ReasonDateFns
open ReactImages
open ReactImages.Carousel
open SWR
open Extensions

%%raw(`import "./activity.scss"`)

@react.component
let make = (~id: string) => {
  let (loadingSlow, setLoadingSlow) = useState(() => false)
  let (modalIsOpen, setModalIsOpen) = useState(() => false)
  let (currentImage, setCurrentImage) = useState(() => 0)
  let {data, error} = useSWR(
    id,
    fetchActivity,
    {
      "onLoadingSlow": () => setLoadingSlow(_ => true),
    },
  )

  let openLightbox = index => {
    setCurrentImage(_ => index)
    setModalIsOpen(_ => true)
  }

  switch (data, error) {
  | (None, None) => <LoadingComponent loadingSlow={loadingSlow} />

  | (None, Some(err)) =>
    Js.Console.error(err)
    <ErrorComponent error={Other(err["message"])} />

  | (Some(data: result<contentData<activityEntryFields>, errors>), None) =>
    switch data {
    | Error(err) => <ErrorComponent error={err} />
    | Ok(data) =>
      let entry = data.entry.fields
      document["title"] = `Preview ― ` ++ entry.title
      let parsedBody = marked(entry.articleBody)
      let parsedDate = Js.Date.fromString(entry.date)

      <>
        <header className="masthead mb-md-2">
          <Container>
            <Row>
              <Col lg={9} md={10} className="mx-auto">
                <div className="post-heading">
                  <h1> {entry.title->string} </h1>
                  <span className="meta">
                    {DateFns.format("d MMMM yyyy", parsedDate)->string}
                  </span>
                </div>
              </Col>
            </Row>
          </Container>
        </header>
        <article>
          {data.images->Array.length > 0
            ? <Masonry
                breakpointCols={data.images->Array.length === 1
                  ? %raw(`{"default": 1}`)
                  : data.images->Array.length <= 6 && mod(data.images->Array.length, 2) === 0
                  ? %raw(`{"default": 2, 640: 1}`)
                  : %raw(`{"default": 4, 1440: 3, 1280: 2, 640: 1}`)}
                className="my-masonry-grid px-md-5 pt-md-5 p-3"
                columnClassName="my-masonry-grid_column">
                {data.images
                ->Belt.Array.mapWithIndex((index, image) => {
                  <div
                    key={index->Belt.Int.toString}
                    role="button"
                    onClick={_ => openLightbox(index)}
                    onKeyPress={e => Js.Console.log("Keypress registered")}
                    tabIndex={0}
                    className="gallery-image-container shadow">
                    <img
                      src={image.url ++ "?w=1200&fm=webp&q=70"}
                      alt={image.description}
                      className="gallery-image rounded fit-cover"
                    />
                    <div className="gallery-image-container-middle">
                      <div className="gallery-image-container-text">
                        {image.description->string}
                      </div>
                    </div>
                  </div>
                })
                ->React.array}
              </Masonry>
            : null}
          <Container>
            <Row>
              <Col
                className="mx-auto px-md-7 px-4 article"
                dangerouslySetInnerHTML={
                  "__html": parsedBody,
                }
              />
            </Row>
          </Container>
        </article>
        {<ModalGateway>
          {modalIsOpen
            ? <Modal onClose={_ => setModalIsOpen(_ => false)}>
                <Carousel
                  views={data.images->Belt.Array.map(img => {
                    source: {
                      regular: img.url ++ "?w=800&fm=webp&q=70",
                      fullscreen: img.url,
                      thumbnail: img.url ++ "?w=250&fm=webp&q=50",
                    },
                    caption: img.description,
                    alt: img.description,
                  })}
                  currentIndex={currentImage}
                  modalProps={"allowFullscreen": false}
                  styles={
                    footerCaption: _ => ReactDOMStyle.make(~fontSize="16", ()),
                  }
                />
              </Modal>
            : null}
        </ModalGateway>}
      </>
    }

  | (_, _) => <div> {"What?"->string} </div>
  }
}
