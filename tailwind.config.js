module.exports = {
  content: ["./src/**/*.{html,js}"],
  theme: {
    extend: {
      colors: {
        accent: {
          DEFAULT: "#f59c22",
        },
        bg: {
          DEFAULT: "#222",
        },
        fg: {
          DEFAULT: "#ddd",
        },
      },
    },
    fontSize: {
      xs: ".75rem",
      sm: ".875rem",
      base: "1rem",
      lg: "1.125rem",
      xl: "1.25rem",
      "2xl": "1.5rem",
      "3xl": "1.875rem",
      "4xl": "2.25rem",
      "5xl": "3rem",
      "6xl": "4rem",
    },
    fontFamily: {
      sans: [
        "Fira Sans",
        "-apple-system",
        "BlinkMacSystemFont",
        "Helvetica Neue",
        "Arial",
        "sans-serif",
      ],
      serif: [
        "Roboto Slab",
        "Georgia",
        "-apple-system",
        "BlinkMacSystemFont",
        "Helvetica Neue",
        "Arial",
        "sans-serif",
      ],
      mono: [
        "Menlo",
        "Monaco",
        "Consolas",
        "Roboto Mono",
        "SFMono-Regular",
        "Segoe UI",
        "Courier",
        "monospace",
      ],
    },
  },
  variants: {
    extend: {},
    width: ["responsive"],
  },
  plugins: [],
};
