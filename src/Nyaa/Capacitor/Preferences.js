import { Preferences } from "@capacitor/preferences";

export const setPreference = (key) => (value) => async () => {
  await Preferences.set({ key, value });
};

export const getPreferenceImpl = (just) => (nothing) => (key) => async () => {
  const ret = await Preferences.get({ key });
  return ret === undefined || ret === null || ret.value === undefined || ret.value === null ? nothing : just(ret.value);
};
