open Client
open ReasonDateFns
open! Extensions

let renderEntry = (entry, images) => {
  open React
  let parsedBody = Marked.marked->Marked.parse(entry.articleBody)
  let parsedDate = Js.Date.fromString(entry.date)

  <>
    <header className="px-64 bg-no-repeat bg-center bg-scroll bg-cover relative">
      <div>
        <div className="row">
          <div className="col mx-auto">
            <div className="py-6">
              <h1 className="text-4xl leading-tight text-accent font-medium">
                {entry.title->string}
              </h1>
              <span className="text-gray-400 mt-2 leading-none block text-xl font-normal">
                {DateFns.format("d MMMM yyyy", parsedDate)->string}
              </span>
            </div>
          </div>
        </div>
      </div>
    </header>
    <article>
      {images->Array.length > 0
        ? <Masonry
            breakpointCols={if images->Js.Array2.length <= 6 && mod(images->Array.length, 2) == 0 {
              Js.Dict.fromArray([("default", 2), ("640", 2)])
            } else if images->Js.Array2.length == 1 {
              Js.Dict.fromArray([("default", 1)])
            } else {
              Js.Dict.fromArray([("default", 4), ("1440", 3), ("1280", 2), ("640", 1)])
            }}
            className="flex -ml-15 w-auto mx-24 p-3"
            columnClassName="pl-2 bg-clip-padding">
            {images
            ->Js.Array2.mapi((image, index) => {
              <div
                key={index->Belt.Int.toString}
                role="button"
                tabIndex={0}
                className="shadow cursor-pointer relative mb-2">
                <img
                  src={image.url ++ "?w=1200&fm=webp&q=70"}
                  className="rounded-md fit-cover opacity-1 block w-full h-auto"
                />
                <div
                  className="bg-black bg-opacity-75 absolute rounded-b-md bottom-0 left-0 py-2 w-full text-center">
                  <div> {image.description->string} </div>
                </div>
              </div>
            })
            ->React.array}
          </Masonry>
        : null}
      <div className="container">
        <div
          className="mx-auto px-64 text-xl"
          dangerouslySetInnerHTML={
            "__html": parsedBody,
          }
        />
      </div>
    </article>
  </>
}

@react.component
let make = (~id: string) => {
  open React
  let {state, isValidating, loadingSlow} = Hooks.useData(id, fetchActivity)

  switch state {
  | Loading => <LoadingComponent loadingSlow={loadingSlow} />
  | Resolved(result) =>
    let data = result->These.mapThisU((. data) => (data.entry["fields"], data.images))
    switch data {
    | That(err) => <ErrorComponent error={err} />
    | This((entry, images)) => {
        document["title"] = `Preview ― ` ++ entry.title
        <> {isValidating ? <Overlay.Spinner /> : null} {renderEntry(entry, images)} </>
      }
    | These((entry, images), _) => {
        document["title"] = `Trouble loading preview ― ` ++ entry.title
        <> {isValidating ? <Overlay.Spinner /> : <Overlay.Error />} {renderEntry(entry, images)} </>
      }
    }
  }
}
