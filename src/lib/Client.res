open Contentful
open Extensions

type imageData = {description: string, url: string}

type activityEntryFields = {
  title: string,
  articleBody: string,
  date: string,
  additionalImages: option<array<asset>>,
}
type eventEntryFields = {
  title: string,
  description: unit,
  eventEndDate: option<string>,
  eventStartDate: string,
  facebookLink: string,
  images: option<array<asset>>,
  slug: string,
  eventVenue: option<string>,
}
type contentData<'fields> = {entry: entry<'fields>, images: array<imageData>}

let client = createClient(
  makeClientOpts(
    ~accessToken=%raw(`import.meta.env.VITE_ACCESS_TOKEN`),
    ~space=%raw(`import.meta.env.VITE_SPACE_ID`),
    ~host="preview.contentful.com",
    (),
  ),
)

let fetchActivity = (id: string): Promise.t<result<contentData<activityEntryFields>, errors>> => {
  client
  ->getEntry(id)
  ->Promise.then(entry => {
    switch entry {
    | None => EntryNotFound->Error->Promise.resolve
    | Some(entry: entry<activityEntryFields>) =>
      if entry["sys"]["contentType"]["sys"]["id"] != "activitiy" {
        InvalidContentType->Error->Promise.resolve
      } else {
        switch entry["fields"].additionalImages {
        | None => {entry: entry, images: []}->Ok->Promise.resolve
        | Some(additionalImages) => {
            let imageAssetPromises = additionalImages->Js.Array2.map(image => {
              let imageAsset = client->getAsset(image["sys"]["id"], ())
              imageAsset->Promise.then(image => {
                Promise.resolve({
                  description: image["fields"]["description"],
                  url: image["fields"]["file"]["url"],
                })
              })
            })
            imageAssetPromises
            ->Promise.all
            ->Promise.then(images => {
              {entry: entry, images: images}->Ok->Promise.resolve
            })
          }
        }
      }
    }
  })
  ->Promise.catch(e => {
    Js.Console.error(e)
    switch e {
    | Promise.JsError(err) => Other(JsError(err))->Error->Promise.resolve
    | _ => Other(String("Unknown."))->Error->Promise.resolve
    }
  })
}

let fetchEvent = (id: string): Promise.t<result<contentData<eventEntryFields>, errors>> =>
  client
  ->getEntry(id)
  ->Promise.then(entry =>
    switch entry {
    | None => EntryNotFound->Error->Promise.resolve
    | Some(entry: entry<eventEntryFields>) =>
      if entry["sys"]["contentType"]["sys"]["id"] != "event" {
        InvalidContentType->Error->Promise.resolve
      } else {
        switch entry["fields"].images {
        | None => {entry: entry, images: []}->Ok->Promise.resolve
        | Some(eventImages) => {
            let imagePromises = eventImages->Js.Array2.map(image => {
              client
              ->getAsset(image["sys"]["id"], ())
              ->Promise.thenResolve(image => {
                {
                  description: image["fields"]["description"],
                  url: image["fields"]["file"]["url"],
                }
              })
            })
            imagePromises
            ->Promise.all
            ->Promise.thenResolve(images => {
              {entry: entry, images: images}->Ok
            })
          }
        }
      }
    }
  )
  ->Promise.catch(e => {
    Js.Console.error(e)
    switch e {
    | Promise.JsError(err) => Other(JsError(err))->Error->Promise.resolve
    | _ => Other(String("Unknown."))->Error->Promise.resolve
    }
  })
