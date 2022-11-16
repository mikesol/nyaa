// Import the functions you need from the SDKs you need
import firebase from "firebase/app";
import "firebase/auth";
import "firebase/firestore";
import "firebase/storage";
import { registerPlugin, Capacitor } from "@capacitor/core";
//// setup
const GameCenterAuth = registerPlugin("GameCenterAuth");
const PlayGamesAuth = registerPlugin("PlayGamesAuth");
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
const app = firebase.initializeApp(firebaseConfig);
const db = firebase.firestore();
const storage = firebase.storage();
if (import.meta.env.DEV) {
  db.useEmulator("localhost", 8080);
  storage.useEmulator("localhost", 9199);
}
db.enablePersistence().catch((err) => {
  if (err.code == "failed-precondition") {
    console.error("could not do offline persistance");
  } else if (err.code == "unimplemented") {
    console.error("browser does not allow for persistance");
  }
});
const auth = app.auth();

///////
// auth
if (import.meta.env.DEV) {
  auth.useEmulator("http://localhost:9099");
}
export const getCurrentUser = () => {
  const result = auth.currentUser;
  return result;
};
export const signInWithGameCenter = async () => {
  const result = await GameCenterAuth.signIn();
  await auth.signInWithCustomToken(result.result);
  return;
};
export const signInWithGoogle = async () => {
  await auth.signInWithPopup(new firebase.auth.GoogleAuthProvider());
};
export const signInWithPlayGames = async () => {
  const result = await PlayGamesAuth.signIn();
  await auth.signInWithCustomToken(result.result);
  return;
};
export const gameCenterEagerAuth = async () => {
  await GameCenterAuth.eagerAuth();
  return;
}
export const signOut = async () => {
  await auth.signOut();
  const platform = Capacitor.getPlatform();
  if (platform === "ios") {
    await GameCenterAuth.signOut();
  } else if (platform === "android") {
    await PlayGamesAuth.signOut();
  }
};

export const listenToAuthStateChange = (cb) => () => {
  const unsub = firebase.auth().onAuthStateChanged((u) => {
    if (u && u.photoURL) {
      var img = new Image();
      img.src = u.photoURL;
    }
    cb(u);
  });
  return unsub;
};

////////////
// firestore

const PROFILE = "profile";

export const getMeImpl = (just) => (nothing) => async () => {
  const docRef = db.collection(PROFILE).doc(auth.currentUser.uid);
  const docSnap = await docRef.get();

  if (docSnap.exists) {
    return just(docSnap.data());
  } else {
    return nothing;
  }
};

export const updateName =
  ({ username }) =>
  async () => {
    const profileDocRef = db.collection(PROFILE).doc(auth.currentUser.uid);
    await profileDocRef.set(
      {
        username,
      },
      { merge: true }
    );
  };

export const updateAvatarUrl =
  ({ avatarUrl }) =>
  async () => {
    const profileDocRef = db.collection(PROFILE).doc(auth.currentUser.uid);
    await profileDocRef.set(
      {
        avatarUrl,
      },
      { merge: true }
    );
  };

export const createOrUpdateProfileAndInitializeListener =
  ({ username, avatarUrl, hasCompletedTutorial, push }) =>
  async () => {
    const profileDocRef = db.collection(PROFILE).doc(auth.currentUser.uid);
    const myProfile = await db.runTransaction(async (transaction) => {
      const profileDoc = await transaction.get(profileDocRef);
      if (!profileDoc.exists) {
        const profile = {};
        if (username) {
          profile.username = username;
        }
        profile.hasCompletedTutorial = hasCompletedTutorial;
        if (avatarUrl) {
          profile.avatarUrl = avatarUrl;
        }
        transaction.set(profileDocRef, profile);
        return profile;
      }
      return profileDoc.data();
    });
    push({ profile: myProfile });
    const unsub = profileDocRef.onSnapshot((doc) => {
      const profileData = doc.data();
      if (profileData.avatarUrl) {
        var img = new Image();
        img.src = profileData.avatarUrl;
      }
      push({ profile: profileData });
    });
    return unsub;
  };

export const uploadAvatar = (bytes) => async () => {
  const storageRef = storage.ref();
  const profileRef = storageRef.child(`nyaaProfileImages/${auth.currentUser.uid}`);
  const metadata = {
    contentType: 'image/jpeg',
  };
  const uploadTask = await profileRef.put(bytes, metadata);
  const url = await uploadTask.ref.getDownloadURL();
  return url;
} 