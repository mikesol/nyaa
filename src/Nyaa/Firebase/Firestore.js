import { doc, getDoc } from "firebase/firestore";

const PROFILE = "PROFILE";

export const getName = (just) => (nothing) => (auth) => async () => {
  const docRef = doc(db, PROFILE, auth.currentUser.uid);
  const docSnap = await getDoc(docRef);
  
  if (docSnap.exists()) {
    return just(docSnap.data());
  } else {
    return nothing;
  }
}