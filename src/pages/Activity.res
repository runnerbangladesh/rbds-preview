open React
open Client
open ReasonDateFns
open Extensions

@react.component
let make = (~id: string) => {
  let {data, isValidating, loadingSlow} = Hooks.useData(id, fetchActivity)

  switch data {
  | None => <LoadingComponent loadingSlow={loadingSlow} />
  | Some(data) =>
    switch data {
    | Error(err) => <ErrorComponent error={err} />
    | Ok(data) => {
        let entry = data.entry["fields"]
        document["title"] = `Preview ― ` ++ entry.title
        let parsedBody = Marked.marked->Marked.parse(entry.articleBody)
        let parsedDate = Js.Date.fromString(entry.date)

        <>
          {isValidating ? <OverlaySpinner /> : null}
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
            {data.images->Array.length > 0
              ? <Masonry
                /* breakpointCols={data.images->Array.length === 1
                    ? %raw(`{"default": 1}`)
                    : data.images->Array.length <= 6 && mod(data.images->Array.length, 2) === 0
                    ? %raw(`{"default": 2, 640: 1}`)
                    : %raw(`{"default": 4, 1440: 3, 1280: 2, 640: 1}`)} */
                  breakpointCols={switch Js.Array2.length(data.images) {
                  | _ if data.images->Array.length <= 6 && mod(data.images->Array.length, 2) == 0 =>
                    Js.Dict.fromArray([("default", 2), ("640", 2)])
                  | 1 => Js.Dict.fromArray([("default", 1)])
                  | _ => Js.Dict.fromArray([("default", 4), ("1440", 3), ("1280", 2), ("640", 1)])
                  }}
                  className="flex -ml-15 w-auto mx-24 p-3"
                  columnClassName="pl-2 bg-clip-padding">
                  {data.images
                  ->Js.Array2.mapi((image, index) => {
                    <div
                      key={index->Belt.Int.toString}
                      role="button"
                      tabIndex={0}
                      className="shadow cursor-pointer relative mb-2">
                      <img
                        src={image.url ++ "?w=1200&fm=webp&q=70"}
                        alt={image.description}
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
    }
  }
}
