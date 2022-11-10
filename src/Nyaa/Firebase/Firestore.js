import { doc, getDoc, runTransaction, onSnapshot } from "firebase/firestore";

const PROFILE = "profile";

export const getMeImpl = (just) => (nothing) => (auth) => async () => {
  console.log('get me', PROFILE, auth.currentUser.uid);
  const docRef = doc(db, PROFILE, auth.currentUser.uid);
  const docSnap = await getDoc(docRef);

  if (docSnap.exists()) {
    return just(docSnap.data());
  } else {
    return nothing;
  }
};

export const createOrUpdateProfileAndInitializeListener =
  ({ db, uid, username, avatarUrl, hasCompletedTutorial, push }) =>
  async () => {
    console.log('createOrUpdateProfileAndInitializeListener', PROFILE, uid);
    const profileDocRef = doc(db, PROFILE, uid);
    const myProfile = await runTransaction(db, async (transaction) => {
      const profileDoc = await transaction.get(profileDocRef);
      if (!profileDoc.exists()) {
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
    const unsub = onSnapshot(profileDocRef, (doc) => {
      push({ profile: doc.data() });
    });
    return unsub;
  };
