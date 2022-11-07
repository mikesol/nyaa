/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,ts,jsx,tsx,purs}",
    "./node_modules/flowbite/**/*.js",
  ],
  theme: {
    extend: {
      backgroundImage: {
        quest: "url('/assets/quest.png')",
        splash: "url('/assets/splash.png')",
        spacecat: "url('/assets/spaceCat.png')",
      },
    },
  },
  plugins: [require("flowbite/plugin")],
};
