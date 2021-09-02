const defaultTheme = require("tailwindcss/defaultTheme");
const colors = require("tailwindcss/colors");

module.exports = {
  mode: "jit",
  purge: ["./js/**/*.js", "../lib/*_web/**/*.*ex"],
  theme: {
    extend: {
      colors: {
        "primary-text": colors.gray[800],
        "warm-gray": colors.warmGray,
        orange: colors.orange,
        amber: colors.amber,
      },
      fontFamily: {
        sans: ["Good Sans", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
