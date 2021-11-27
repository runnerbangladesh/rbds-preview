open React
open Bootstrap
open Client
open ReasonDateFns
open Extensions

%%raw(`import "./activity.scss"`)

@react.component
let make = (~id: string) => {
  let (loadingSlow, setLoadingSlow) = useState(_ => false)
  let {data} = Swr.useSWR_config(id, fetchActivity, Swr.swrConfiguration(~onLoadingSlow=(_, _) => {
      setLoadingSlow(_ => true)
    }, ()))

  switch data {
  | None => <LoadingComponent loadingSlow={loadingSlow} />

  | Some(data) =>
    switch data {
    | Error(err) => <ErrorComponent error={err} />
    | Ok(data) => {
        let entry = data.entry.fields
        document["title"] = `Preview ― ` ++ entry.title
        let parsedBody = Marked.marked->Marked.parse(entry.articleBody)
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
        </>
      }
    }
  }
}
