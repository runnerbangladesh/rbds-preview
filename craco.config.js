const purgecss = require("@fullhuman/postcss-purgecss");

module.exports = {
  style: {
    postcss: {
      plugins: [
        purgecss({
          content: [
            "./src/**/*.tsx",
            "./src/**/*.ts",
            "./src/**/*.jsx",
            "./src/**/*.js",
          ],
          css: ["./src/pages/activity.scss"],
          rejected: true,
        }),
      ],
    },
  },
};
