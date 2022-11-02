import { FirebaseAuthentication } from "@capacitor-firebase/authentication";


export const getCurrentUser = async () => {
  const result = await FirebaseAuthentication.getCurrentUser();
  return result;
};
export const signInWithApple = async () => {
  const result = await FirebaseAuthentication.signInWithApple();
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

export const listenToAuthStateChange = (listener) => () => FirebaseAuthentication.addListener('authStateChange', listener);
