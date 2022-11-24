// Import the functions you need from the SDKs you need
import firebase from "firebase/app";
import "firebase/auth";
import "firebase/firestore";
import "firebase/storage";
import "firebase/analytics";
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
};
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
const MATCHMAKING = "matchmaking";
const YENTA = "yenta";

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

export const genericUpdateImpl = (kvs) => async () => {
  const profileDocRef = db.collection(PROFILE).doc(auth.currentUser.uid);
  await profileDocRef.set(kvs, { merge: true });
};

export const updateViaTransactionImpl = (f) => (k) => (v) => async () => {
  const profileDocRef = db.collection(PROFILE).doc(auth.currentUser.uid);
  const myProfile = await db.runTransaction(async (transaction) => {
    const profileDoc = await transaction.get(profileDocRef);
    if (!profileDoc.exists) {
      const o = { [k]: v };
      transaction.set(profileDocRef, o);
      return o;
    }
    const pd = profileDoc.data();
    const rk = pd[k];
    const o = { ...pd };
    if (rk !== undefined) {
      o[k] = f(pd[k]);
    } else {
      o[k] = v;
    }
    transaction.set(profileDocRef, o);
    return o;
  });
  return myProfile;
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
  const profileRef = storageRef.child(
    `nyaaProfileImages/${auth.currentUser.uid}`
  );
  const metadata = {
    contentType: "image/jpeg",
  };
  const uploadTask = await profileRef.put(bytes, metadata);
  const url = await uploadTask.ref.getDownloadURL();
  return url;
};

export const cancelTicket = async () => {
  const matchmakingDocRef = db.collection(MATCHMAKING).doc(YENTA);
  await db.runTransaction(async (transaction) => {
    const uid = auth.currentUser.uid;
    const matchmakingDoc = await transaction.get(matchmakingDocRef);
    if (!matchmakingDoc.exists) {
      return;
    }
    const yentaRemote = matchmakingDoc.data();
    const yentaLocal = { ...yentaRemote };
    // if the previous game was full or the current player1 is squatting
    if (yentaLocal.player1 === uid) {
      yentaLocal.player1 = firebase.firestore.FieldValue.delete();
      transaction.set(matchmakingDocRef, yentaLocal, { merge: true });
      return;
    }
    return;
  });
};
// is too long too long?
const TOO_LONG = 7000.0;
export const createTicketImpl =
  (nothing) => (just) => (room) => (push) => async () => {
    console.log("creating ticket");
    const matchmakingDocRef = db.collection(MATCHMAKING).doc(`${YENTA}${room}`);
    const profileDocRef = db.collection(PROFILE).doc(auth.currentUser.uid);
    const myTicket = await db.runTransaction(async (transaction) => {
      const uid = auth.currentUser.uid;
      const [profileDoc, matchmakingDoc] = await Promise.all([
        transaction.get(profileDocRef),
        transaction.get(matchmakingDocRef),
      ]);
      const profileData = profileDoc.data();
      const timestamp = new Date().getTime();
      if (!matchmakingDoc.exists) {
        console.log("creating mm doc and claiming player 1");
        const o = {
          player1: uid,
          player1Timestamp: timestamp,
          player1Name: profileData.username,
        };
        transaction.set(matchmakingDocRef, o, { merge: true });
        const oo = { ...o };
        oo.player2 = nothing;
        oo.player2Name = nothing;
        return oo;
      }
      const yentaRemote = matchmakingDoc.data();
      const yentaLocal = { ...yentaRemote };
      // if the previous game was full or the current player1 is squatting
      if (
        (yentaLocal.player1 && yentaLocal.player2) ||
        yentaLocal.player1Timestamp < timestamp - TOO_LONG
      ) {
        console.log(
          "claiming player 1",
          yentaLocal,
          yentaLocal.player1Timestamp,
          timestamp
        );
        yentaLocal.player1 = uid;
        yentaLocal.player1Timestamp = timestamp;
        yentaLocal.player1Name = profileData.username;
        yentaLocal.player2 = firebase.firestore.FieldValue.delete();
        yentaLocal.player2Timestamp = firebase.firestore.FieldValue.delete();
        yentaLocal.player2Name = firebase.firestore.FieldValue.delete();
        transaction.set(matchmakingDocRef, yentaLocal, { merge: true });
        return {
          player1: uid,
          player1Name: profileData.username,
          player2: nothing,
          player2Name: nothing,
        };
      }
      if (!yentaLocal.player2) {
        console.log("claiming player 2");
        yentaLocal.player2 = uid;
        yentaLocal.player2Timestamp = timestamp;
        yentaLocal.player2Name = profileData.username;
        transaction.set(matchmakingDocRef, yentaLocal);
        const o = { ...yentaLocal };
        o.player2 = just(yentaLocal.player2);
        o.player2Name = just(yentaLocal.player2Name);
        return o;
      }
      // we should never get here as if we're in the matchmaking queue then we should never hit something
      // that doesn't correspond with one of the above conditions
      throw new Error(
        `Programming error: inconsistent state ${timestamp} ${JSON.stringify(
          yentaRemote
        )}`
      );
    });
    console.log("pushing my ticket");
    push(myTicket)();
    const unsub = matchmakingDocRef.onSnapshot((doc) => {
      const ticket = doc.data();
      if (ticket.player2) {
        ticket.player2 = just(ticket.player2);
      }
      if (ticket.player2Name) {
        ticket.player2Name = just(ticket.player2Name);
      }
      console.log("pushing incoming ticket", ticket);
      push(ticket)();
    });
    return unsub;
  };


// Initialize Analytics and get a reference to the service


export const logPageNavToAnalytics = (path) => () => {
  firebase.analytics().logEvent("page_nav", {
    path,
  });
};

export const setUserId = (userId) => () => {
  firebase.analytics().setUserId(userId);
}

