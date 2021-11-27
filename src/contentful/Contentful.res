type t

type contentTypeLink = {"type": [#Link], "linkType": [#ContentType], "id": string}

type sys = {
  "type": string,
  "id": string,
  "createdAt": string,
  "updatedAt": string,
  "locale": string,
  "revision": int,
  "contentType": {"sys": contentTypeLink},
}

type contentfulEntry<'t> = {sys: sys, fields: 't}

type contentfulAsset = {
  "sys": sys,
  "fields": {
    "title": string,
    "description": string,
    "file": {
      "url": string,
      "details": {"size": int, "image": {"width": int, "height": int}},
      "fileName": string,
      "contentType": string,
    },
  },
}

type clientOpts = {
  accessToken: string,
  space: string,
  host: string,
}

@module("contentful")
external createClient: clientOpts => t = "createClient"

@send external getEntry: (t, string) => Promise.t<option<contentfulEntry<'field>>> = "getEntry"
@send external getAsset: (t, string) => Promise.t<contentfulAsset> = "getAsset"

@module("@contentful/rich-text-react-renderer")
external documentToReactComponents: 'obj => React.element = "documentToReactComponents"
