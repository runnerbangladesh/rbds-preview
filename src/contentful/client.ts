import * as contentful from "contentful";

interface ImageData {
  description: string;
  url: string;
}

interface ActivityEntryFields {
  title: string;
  additionalImages: contentful.Asset[] | undefined;
}
interface EventEntryFields {
  title: string;
  body: string;
  eventEndDate: string;
  eventStartDate: string;
  facebookLink: string;
  images: contentful.Asset[];
  slug: string;
  eventVenue: string;
}
interface ActivityData {
  entry: contentful.Entry<ActivityEntryFields>;
  images?: ImageData[];
}
interface EventData {
  entry: contentful.Entry<EventEntryFields>;
  images?: ImageData[];
}

class InvalidContentTypeError extends Error {
  constructor(message = "") {
    super(message);
    this.message =
      "Entry ID does not match content type. Go back and try again.";
  }
}
class EntryNotFoundError extends Error {
  constructor(message = "") {
    super(message);
    this.message = "Entry not found";
  }
}

const client = contentful.createClient({
  accessToken: process.env.REACT_APP_ACCESS_TOKEN as string,
  space: process.env.REACT_APP_SPACE_ID as string,
  host: "preview.contentful.com",
});

export async function fetchActivity(id: string): Promise<ActivityData> {
  try {
    const entry = await client.getEntry<ActivityEntryFields>(id);

    if (entry.sys.contentType.sys.id !== "activitiy")
      throw new InvalidContentTypeError();
    if (!entry) throw new EntryNotFoundError();
    if (!entry.fields.additionalImages) return { entry };

    const promises = entry.fields.additionalImages.map(async (image) => {
      const asset = await client.getAsset(image.sys.id);
      return {
        description: asset.fields.description,
        url: asset.fields.file.url,
      };
    });
    const images = await Promise.all(promises);
    return {
      entry,
      images,
    };
  } catch (e) {
    throw e;
  }
}

export async function fetchEvent(id: string): Promise<EventData> {
  try {
    const entry = await client.getEntry<EventEntryFields>(id);

    if (entry.sys.contentType.sys.id !== "event")
      throw new InvalidContentTypeError();
    if (!entry) throw new EntryNotFoundError();
    if (!entry.fields.images) return { entry };

    const promises = entry.fields.images.map(async (image) => {
      const asset = await client.getAsset(image.sys.id);
      return {
        description: asset.fields.description,
        url: asset.fields.file.url,
      };
    });
    const images = await Promise.all(promises);
    return {
      entry,
      images,
    };
  } catch (e) {
    throw e;
  }
}
