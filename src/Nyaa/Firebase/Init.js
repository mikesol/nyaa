// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getFirestore, connectFirestoreEmulator, enableIndexedDbPersistence } from "firebase/firestore";
import { getAuth, connectAuthEmulator } from "firebase/auth";
import { getFunctions } from "firebase/functions";

// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyApcNptrGT_uafnXmkLVtTkSZLhqGyXbrM",
  authDomain: "nyaa-game.firebaseapp.com",
  databaseURL: "https://nyaa-game-default-rtdb.firebaseio.com",
  projectId: "nyaa-game",
  storageBucket: "nyaa-game.appspot.com",
  messagingSenderId: "339754466261",
  appId: "1:339754466261:web:1de09305db8a48d1b61b5c",
  measurementId: "G-M8P30T53P0",
};

// Initialize Firebase
export const fbApp = () => initializeApp(firebaseConfig);
export const fbFunctions = (app) => () => import.meta.env.PROD ? getFunctions(app) : getFunctions();
export const fbAnalytics = (app) => () =>
  import.meta.env.PROD ? getAnalytics(app) : undefined; // ugggh
export const fbDB = (app) => () => {
  const o = import.meta.env.PROD ? getFirestore(app) : getFirestore();
  connectFirestoreEmulator(o, "localhost", 8080);
  // let this run async
  // it's highly unlikely there will ever be a race condition
  // if needed return this as a promise & chain `o`
  enableIndexedDbPersistence(o).catch((err) => {
    if (err.code == "failed-precondition") {
      console.error("could not do offline persistance");
    } else if (err.code == "unimplemented") {
      console.error("browser does not allow for persistance");
    }
  });
  return o;
};
export const fbAuth = (app) => () => {
  const o = import.meta.env.PROD ? getAuth(app) : getAuth();
  if (import.meta.env.DEV) {
    connectAuthEmulator(o, "http://localhost:9099");
  }
  return o;
};
