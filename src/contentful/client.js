const contentful = require("contentful");

const client = contentful.createClient({
  accessToken: process.env.REACT_APP_ACCESS_TOKEN,
  space: process.env.REACT_APP_SPACE_ID,
  host: "preview.contentful.com",
});

export const getImages = async (entryId) => {
  try {
    const entry = await client.getEntry(entryId);

    if (!entry.fields.additionalImages) {
      return null;
    }
    const promises = entry.fields.additionalImages.map(async (entry) => {
      const asset = await client.getAsset(entry.sys.id);
      return {
        description: asset.fields.description,
        url: asset.fields.file.url,
      };
    });
    return await Promise.all(promises);
  } catch (e) {
    console.log("erroror");
  }
};

export default client;
