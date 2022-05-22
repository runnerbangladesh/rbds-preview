open Client
open ReasonDateFns
open! Extensions

let renderEntry = (entry, images) => {
  open React
  open! Js

  let parsedBody = Marked.marked->Marked.parse(entry.articleBody)
  let parsedDate = Date.fromString(entry.date)

  <>
    <header className="pt-12 px-4 md:px-64 bg-no-repeat bg-center bg-scroll bg-cover relative">
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
            breakpointCols={if images->Array2.length <= 6 && mod(images->Array.length, 2) == 0 {
              Dict.fromArray([("default", 2), ("640", 2)])
            } else if images->Js.Array2.length == 1 {
              Dict.fromArray([("default", 1)])
            } else {
              Dict.fromArray([("default", 4), ("1440", 3), ("1280", 2), ("640", 1)])
            }}
            className="flex -ml-15 w-auto md:mx-24 p-3"
            columnClassName="pl-2 bg-clip-padding">
            {images
            ->Array2.mapi((image, index) => {
              <div
                key={index->Belt.Int.toString}
                role="button"
                tabIndex={0}
                className="shadow cursor-pointer relative mb-2">
                <img
                  src={image.url ++ "?w=1200&fm=webp&q=70"}
                  className="rounded-md fit-cover opacity-1 block w-full h-auto"
                />
                {image.description != ""
                  ? <div
                      className="bg-black bg-opacity-75 absolute rounded-b-md bottom-0 left-0 py-2 w-full text-center">
                      <div> {image.description->string} </div>
                    </div>
                  : React.null}
              </div>
            })
            ->React.array}
          </Masonry>
        : React.null}
      <div className="container">
        <div
          className="mx-auto px-4 md:px-64 text-xl"
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
  open! Js

  let {state, isValidating, loadingSlow, mutate} = Hooks.useData(id, fetchActivity)

  let status = (slug, isError) =>
    <Status
      title="Activity Preview"
      isValidating={isValidating}
      canonicalUrl={"https://runnerbangladesh.org/activities/" ++ slug}
      isError={isError}
      onRefresh={() => {
        mutate(. Some(data => Promise.resolve(data->Option.getExn)), None)->ignore
      }}
    />

  switch state {
  | Loading => <LoadingComponent loadingSlow={loadingSlow} />
  | Resolved(result) =>
    let data = result->These.mapThisU((. data) => (data.entry["fields"], data.images))
    switch data {
    | That(err) => <ErrorComponent error={err} />
    | This((entry, images)) => {
        document["title"] = `Preview ― ` ++ entry.title
        <> {status(entry.slug, false)} {renderEntry(entry, images)} </>
      }
    | These((entry, images), _) => {
        document["title"] = `Trouble loading preview ― ` ++ entry.title
        <>
          {status(entry.slug, true)}
          {renderEntry(entry, images)}
        </>
      }
    }
  }
}
