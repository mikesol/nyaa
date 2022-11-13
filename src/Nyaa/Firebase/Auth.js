// import { FirebaseAuthentication } from "@capacitor-firebase/authentication/src/";
import { registerPlugin } from "@capacitor/core";
import { signInWithCustomToken } from "firebase/auth";
import axios from "axios";
const GameCenterAuth = registerPlugin("GameCenterAuth");

export const getCurrentUser = (auth) => async () => {
  const result = await auth.currentUser;
  return { user: result };
};
export const signInWithGameCenter = (auth) => async () => {
  //console.log("started signInWithGameCenter");
  const result = await GameCenterAuth.signIn();
  //console.log("got result", result);
  // const token = await axios.post("https://us-central1-nyaa-game.cloudfunctions.net/gcAuth", result);
  //console.log("TOKEY", token);
  console.log('signing in using token');
  try {
    const userCredential = await signInWithCustomToken(auth, result.result);
    const user = userCredential.user;
    console.log("User", user);
    return { user };  
  } catch (e)  {
    console.error(e);
  }
};
export const signOut = (auth) => async () => {
  await auth.signOut();
};

export const signInWithGoogle = () => async () => {
  throw new Error("unimplemented");
};

export const signInWithPlayGames = () => async () => {
  throw new Error("unimplemented");
};

export const listenToAuthStateChange = () => () => () => () => {};
