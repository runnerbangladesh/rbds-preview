open Contentful
open Extensions

type imageData = {description: string, url: string}

type activityEntryFields = {
  title: string,
  articleBody: string,
  date: string,
  additionalImages: option<array<asset>>,
  slug: string,
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

let client = createClient({
  accessToken: %raw(`import.meta.env.VITE_ACCESS_TOKEN`),
  space: %raw(`import.meta.env.VITE_SPACE_ID`),
  host: "preview.contentful.com",
})

let fetchActivity = (id: string): promise<contentData<activityEntryFields>> => {
  client
  ->getEntry(id)
  ->Promise.then(entry => {
    switch entry {
    | None => EntryNotFound->Promise.reject
    | Some(entry: entry<activityEntryFields>) =>
      if entry["sys"]["contentType"]["sys"]["id"] != "activitiy" {
        InvalidContentType->Promise.reject
      } else {
        switch entry["fields"].additionalImages {
        | None => {entry, images: []}->Promise.resolve
        | Some(additionalImages) => {
            let imageAssetPromises = additionalImages->Array.map(image => {
              let imageAsset = client->getAsset(image["sys"]["id"])
              imageAsset->Promise.then(
                image => {
                  Promise.resolve({
                    description: image["fields"]["description"],
                    url: image["fields"]["file"]["url"],
                  })
                },
              )
            })
            imageAssetPromises
            ->Promise.all
            ->Promise.then(images => {
              {entry, images}->Promise.resolve
            })
          }
        }
      }
    }
  })
}

let fetchEvent = (id: string) =>
  client
  ->getEntry(id)
  ->Promise.then(entry =>
    switch entry {
    | None => EntryNotFound->Promise.reject
    | Some(entry: entry<eventEntryFields>) =>
      if entry["sys"]["contentType"]["sys"]["id"] != "event" {
        InvalidContentType->Promise.reject
      } else {
        switch entry["fields"].images {
        | None => {entry, images: []}->Promise.resolve
        | Some(eventImages) => {
            let imagePromises = eventImages->Array.map(image => {
              client
              ->getAsset(image["sys"]["id"])
              ->Promise.thenResolve(
                image => {
                  {
                    description: image["fields"]["description"],
                    url: image["fields"]["file"]["url"],
                  }
                },
              )
            })
            imagePromises
            ->Promise.all
            ->Promise.thenResolve(images => {
              {entry, images}
            })
          }
        }
      }
    }
  )
