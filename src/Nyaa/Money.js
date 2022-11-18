import { store } from "cordova-plugin-purchase";
import { Capacitor } from "@capacitor/core";

const PRODUCT_ID =
  Capacitor.getPlatform() === "ios" ? "nyaa.track.ac.0" : "nyaa.track.ac.0";

export const registerPaidSong = () => {
  if (Capacitor.getPlatform() !== "web") {
    store.register({
      id: PRODUCT_ID,
      type: store.NON_CONSUMABLE,
    });
  }
};

export const buy = (fail) => (success) => () => {
  store
    .when(PRODUCT_ID)
    .approved((p) => {
      return p.verify();
    })
    .verified((p) => {
      p.finish();
      success();
    });
  store.order(PRODUCT_ID).then(
    () => {},
    (e) => {
      fail(e);
    }
  );
};

export const isOwned = () => {
  return store.get(PRODUCT_ID).owned === true;
};
