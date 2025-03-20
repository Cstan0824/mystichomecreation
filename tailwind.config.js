/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ["./src/main/webapp/**/*.jsp"],
    theme: {
        screens: {
            sm: "375px",
            md: "768px",
            lg: "1024px",
            xl: "1440px",
        },
        extend: {
            fontFamily: {
                poppins: ["Poppins", "sans-serif"],
                dmSans: ["DM Sans", "sans-serif"],
            },
            colors: {
                lightYellow: "#FFFAE9",
                lightMidYellow: "#FFE982",
                darkYellow: "#EFAC00",

                brown1: "#FFFACD",
                brown2: "#D0B07E",
                brown3: "#B07B2A",
                brown4: "#6F4E25",
                brown5: "#382814",

                orange1: "#FDD3B0",
                orange2: "#F48355",
                orange3: "#F16321",
                orange4: "#B34C26",
                orange5: "#7A3117",

                red1: "#FFF4F4",
                red2: "#EE4056",
                red3: "#D52229",
                red4: "#991B1E",
                red5: "#4B1718",

                grey1: "#F5F5F5",
                grey2: "#E5E5E1",
                grey3: "#C0BFBB",
                grey4: "#75716B",
                grey5: "#383633",

                magenta1: "#F7B7D3",
                magenta2: "#D9559F",
                magenta3: "#962E66",
                magenta4: "#65154B",
                magenta5: "#4B1139",

                purple1: "#CB9DC8",
                purple2: "#A95EA5",
                purple3: "#8A459A",
                purple4: "#592466",
                purple5: "#2E1533",

                violet1: "#D3C2DF",
                violet2: "#926FB0",
                violet3: "#6955A3",
                violet4: "#313183",
                violet5: "#181241",

                blue1: "#C4DDF3",
                blue2: "#32B1E6",
                blue3: "#0082AD",
                blue4: "#003F5B",
                blue5: "#0C202C",

                green1: "#CADBC6",
                green2: "#64C085",
                green3: "#00B485",
                green4: "#034126",
                green5: "#034126",

                cyan1: "#BEE2D6",
                cyan2: "#00A9A4",
                cyan3: "#00918A",
                cyan4: "#006A61",
                cyan5: "#003531",

                primary: {
                    50: "#ffffe7",
                    100: "#ffffc1",
                    200: "#fffb86",
                    300: "#fff141",
                    400: "#ffe10d",
                    500: "#ffd200",
                    600: "#d19a00",
                    700: "#a66e02",
                    800: "#89550a",
                    900: "#74460f",
                    950: "#442404",
                },
            },
        },
    },
    plugins: [],
};
