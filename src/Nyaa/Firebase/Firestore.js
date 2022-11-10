import { doc, getDoc, runTransaction, onSnapshot } from "firebase/firestore";

const PROFILE = "PROFILE";

export const getMeImpl = (just) => (nothing) => (auth) => async () => {
  const docRef = doc(db, PROFILE, auth.currentUser.uid);
  const docSnap = await getDoc(docRef);

  if (docSnap.exists()) {
    return just(docSnap.data());
  } else {
    return nothing;
  }
};

export const creataeOrUpdateProfileAndInitializeListener =
  ({ db, uid, username, avatarUrl, hasCompletedTutorial, push }) =>
  async () => {
    const profileDocRef = doc(db, PFORILE, uid);
    const myProfile = await runTransaction(db, async (transaction) => {
      const profileDoc = await transaction.get(profileDocRef);
      if (!profileDoc.exists()) {
        const profile = {};
        profile.username = username;
        profile.hasCompletedTutorial = hasCompletedTutorial;
        if (avatarUrl) {
          profile.avatarUrl = avatarUrl;
        }
        transaction.set(profileDocRef, profile);
        return profile;
      }

      return profileDoc.data();
    });
    push(profile);
    const unsub = onSnapshot(profileDocRef, (doc) => {
      push(doc.data());
    });
    return unsub;
  };
