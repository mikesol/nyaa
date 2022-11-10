import { FirebaseAuthentication } from "@capacitor-firebase/authentication/src/";

export const useEmulator = async () => {
  const result = await FirebaseAuthentication.useEmulator({
    host: "http://127.0.0.1",
    port: 9099,
  });
  return result;
};
export const getCurrentUser = async () => {
  const result = await FirebaseAuthentication.getCurrentUser();
  return result;
};
export const signInWithApple = async () => {
  const result = await FirebaseAuthentication.signInWithApple();
  return result;
};

export const signInWithGameCenter = async () => {
  console.log('signing in');
  const result = await FirebaseAuthentication.signInWithGameCenter();
  console.log('sign in result', result);
  return result;
};

export const signInWithGoogle = async () => {
  const result = await FirebaseAuthentication.signInWithGoogle();
  return result;
};

export const signInWithPlayGames = async () => {
  const result = await FirebaseAuthentication.signInWithPlayGames();
  return result;
};

export const listenToAuthStateChange = (listener) => () =>
  FirebaseAuthentication.addListener("authStateChange", listener);

export const signOut = async () => {
  await FirebaseAuthentication.signOut();
};
