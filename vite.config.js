import * as path from "path";
export default {
    resolve: {
        alias: {
            PureScript: process.env.NODE_ENV === 'production'
              ? path.resolve(__dirname, "output-es/Main/")
              : path.resolve(__dirname, "output/Main/"),
          },
    }
}