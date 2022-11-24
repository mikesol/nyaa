import { App } from "@capacitor/app";

export const onBackgrounded = (cb) => () => {
  App.addListener("appStateChange", ({ isActive }) => {
    console.log("appStateChange", isActive);
    if (!isActive) {
      cb();
    }
  });

  App.addListener("pause", () => {
    console.log("pausing");
    cb();
  });
};
