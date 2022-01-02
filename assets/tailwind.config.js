const defaultTheme = require("tailwindcss/defaultTheme");
const colors = require("tailwindcss/colors");

module.exports = {
  content: ["./js/**/*.js", "../lib/*_web/**/*.*ex"],
  theme: {
    extend: {
      maxHeight: {
        0: "0",
        "1/4": "25%",
        "1/2": "50%",
        "3/4": "75%",
        "4/5": "80%",
      },
      colors: {
        background: colors.stone[50],
        "primary-text": colors.gray[700],
        "secondary-text": colors.gray[500],
        "primary-border": colors.stone[300],
        "dark-border": colors.stone[500],
        "darker-border": colors.stone[700],
        "secondary-border": colors.stone[200],
        "lightest-border": colors.stone[100],
        "primary-border-darker": colors.stone[400],
        "primary-error": colors.red[500],
        primary: colors.gray[900],
        accent: colors.orange[400],
      },
      fontFamily: {
        sans: ["Good Sans", ...defaultTheme.fontFamily.sans],
      },
      keyframes: {
        thruttle: {
          from: {
            transform: "translateX(-2px)",
          },
          to: {
            transform: "translateX(2px)",
          }

        }
      },
      animation: {
        thruttle: 'thruttle 0.2s alternate infinite'
      }
    },
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
