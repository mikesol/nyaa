// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getFirestore, connectFirestoreEmulator } from "firebase/firestore";
import { getAuth, connectAuthEmulator } from "firebase/auth";

// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyDnH-XCA_h3AoC3BKxKc8nYycI17Dut4uM",
  authDomain: "mystery-mansion-madness-dc8f5.firebaseapp.com",
  projectId: "mystery-mansion-madness-dc8f5",
  storageBucket: "mystery-mansion-madness-dc8f5.appspot.com",
  messagingSenderId: "56529113235",
  appId: "1:56529113235:web:87f009c3328bd576443d66",
  measurementId: "G-QEK18Z3GM5",
};

// Initialize Firebase
export const app = initializeApp(firebaseConfig);
export const analytics = getAnalytics(app);
export const db = import.meta.env.PROD ? getFirestore(app) : getFirestore();
export const auth = import.meta.env.PROD ? getAuth(app) : getAuth();
if (import.meta.env.DEV) {
  connectFirestoreEmulator(db, "localhost", 8080);
  connectAuthEmulator(auth, "http://localhost:9099");
}
