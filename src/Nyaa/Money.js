import { registerPlugin } from "@capacitor/core";

const Money = registerPlugin("Money");

export const buy = (fail) => (success) => () => {
  Money.buy().then(
    () => {
      success();
    },
    (e) => {
      console.error(e);
      fail();
    }
  );
};
