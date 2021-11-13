const defaultTheme = require("tailwindcss/defaultTheme");
const colors = require("tailwindcss/colors");

module.exports = {
  mode: "jit",
  purge: ["./js/**/*.js", "../lib/*_web/**/*.*ex"],
  theme: {
    colors: {
      background: colors.warmGray[50],
      "primary-text": colors.gray[800],
      "secondary-text": colors.gray[500],
      "primary-border": colors.warmGray[300],
      "dark-border": colors.warmGray[500],
      "darker-border": colors.warmGray[700],
      "secondary-border": colors.warmGray[200],
      "lightest-border": colors.warmGray[100],
      "primary-border-darker": colors.warmGray[400],
      "primary-error": colors.red[500],
      primary: colors.gray[900],
      accent: colors.orange[400],
      "warm-gray": colors.warmGray,
      orange: colors.orange,
      amber: colors.amber,
    },
    fontFamily: {
      sans: ["Good Sans", ...defaultTheme.fontFamily.sans],
    },
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/aspect-ratio"),
  ],
};
