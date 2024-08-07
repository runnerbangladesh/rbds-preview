let frames: array<string> = [`⠋`, `⠙`, `⠹`, `⠸`, `⠼`, `⠴`, `⠦`, `⠧`, `⠇`, `⠏`]

@react.component
let make = (
  ~isValidating=false,
  ~isError=false,
  ~onRefresh=() => {()},
  ~title="",
  ~canonicalUrl: option<string>=?,
  (),
) => {
  open React

  let (frame, setFrame) = useState(_ => 0)

  useEffect1(() => {
    let length = frames->Array.length

    let anim = setInterval(() => {
      setFrame(i => i + 1 == length ? 0 : i + 1)
    }, 150)

    Some(() => clearInterval(anim))
  }, [])

  <div className="fixed w-full z-10 bg-black text-white flex justify-between">
    <div className="flex p-2 md:p-4 items-center">
      <span className="mr-3 grow shrink-0"> {title->String.toUpperCase->string} </span>
      {!isValidating
        ? <span className="text-zinc-500 shrink">
            {frames->Array.getUnsafe(frame)->React.string}
            {" "->string}
            <span className="hidden md:inline"> {"Watching for changes..."->string} </span>
          </span>
        : React.null}
    </div>
    <div className="flex items-center gap-3">
      {switch canonicalUrl {
      | Some(url) =>
        <a href={url} target="_blank" className="shrink" title="Canonical URL">
          <Icons.External />
        </a>
      | None => React.null
      }}
      <button
        disabled={isValidating}
        onClick={_ => onRefresh()}
        title={isError
          ? "Error refreshing data. Check network connection and retry"
          : "Manual Reload"}
        className="bg-zinc-700 p-2 md:p-4 h-full">
        {isValidating ? <Overlay.Spinner /> : isError ? <Overlay.Error /> : "REFRESH"->string}
      </button>
    </div>
  </div>
}
