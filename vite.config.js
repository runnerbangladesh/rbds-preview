import { defineConfig } from "vite";
import reactRefresh from "@vitejs/plugin-react-refresh";
import reactJsx from "vite-react-jsx";

export default defineConfig({
  plugins: [reactRefresh(), reactJsx()],
  resolve: {
    alias: [
      {
        // Workaround for an import related bug.
        // See more: https://github.com/contentful/contentful-sdk-core/issues/120
        find: "contentful-sdk-core",
        replacement: "contentful-sdk-core/dist/index.js",
      },
    ],
  },
});
