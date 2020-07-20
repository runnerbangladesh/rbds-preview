import * as contentful from "contentful";

interface ActivityEntryFields {
  title: string;
  additionalImages: contentful.Asset[] | undefined;
}
interface ActivityData {
  entry: contentful.Entry<ActivityEntryFields>;
  images?: {
    description: string;
    url: string;
  }[];
}

const client = contentful.createClient({
  accessToken: process.env.REACT_APP_ACCESS_TOKEN as string,
  space: process.env.REACT_APP_SPACE_ID as string,
  host: "preview.contentful.com",
});

const fetcher = async (id: string): Promise<ActivityData> => {
  try {
    const entry = await client.getEntry<ActivityEntryFields>(id);

    if (!entry) throw new Error();
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
};

export default fetcher;
