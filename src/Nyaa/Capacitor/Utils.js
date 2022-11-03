import { Capacitor } from "@capacitor/core";

export const getPlatformImpl = (web) => (ios) => (android) => () => {
  const platform = Capacitor.getPlatform();
  return platform === "ios"
    ? ios
    : platform === "android"
    ? android
    : platform === "web"
    ? web
    : (() => {
        throw new Error(`Unknown platform: ${platform}`);
      })();
};
