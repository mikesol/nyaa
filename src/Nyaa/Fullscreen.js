import { AndroidFullScreen } from "@awesome-cordova-plugins/android-full-screen/";

export const androidFullScreen = () =>
  AndroidFullScreen.isImmersiveModeSupported()
    .then(() => AndroidFullScreen.immersiveMode())
    .catch(console.warn);
