import { auth } from "./init";
import { signInAnonymously } from "firebase/auth";
export const doSignIn = () => signInAnonymously(auth);
