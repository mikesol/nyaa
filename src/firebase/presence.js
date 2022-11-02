import firestore from "firebase/firestore";
import database from "firebase/database";
import { auth, app, db as fsdb } from "./init";

export const doPresence = () => {
    var uid = auth.currentUser.uid;
    var db = database.getDatabase(import.meta.env.VITE_FIREBASE_BUILD === "production" ? app : undefined);
    if (!import.meta.env.PROD) {
        database.connectDatabaseEmulator(db, "localhost", 9000);
    }

    var userStatusDatabaseRef = database.ref(db, '/status/' + uid);
    var isOfflineForDatabase = {
        state: 'offline',
        last_changed: database.serverTimestamp(),
    };

    var isOnlineForDatabase = {
        state: 'online',
        last_changed: database.serverTimestamp(),
    };

    var userStatusFirestoreRef = firestore.doc(fsdb, '/status/' + uid);

    // Firestore uses a different server timestamp value, so we'll 
    // create two more constants for Firestore state.
    var isOfflineForFirestore = {
        state: 'offline',
        last_changed: firestore.serverTimestamp(),
    };

    var isOnlineForFirestore = {
        state: 'online',
        last_changed: firestore.serverTimestamp(),
    };

    const retval = database.onValue(database.ref(db, '.info/connected'), function (snapshot) {

        if (snapshot.val() == false) {
            // Instead of simply returning, we'll also set Firestore's state
            // to 'offline'. This ensures that our Firestore cache is aware
            // of the switch to 'offline.'
            console.log('not connected to rtdb');
            firestore.setDoc(userStatusFirestoreRef, isOfflineForFirestore);
            return;
        }
        database.onDisconnect(userStatusDatabaseRef).set(isOfflineForDatabase).then(function () {
            console.log('connected to rtdb');
            database.set(userStatusDatabaseRef, isOnlineForDatabase);
            // We'll also add Firestore set here for when we come online.
            firestore.setDoc(userStatusFirestoreRef, isOnlineForFirestore);
        });
    });
    return () => {
        retval();
        database.onDisconnect(userStatusDatabaseRef).set(null);
    }
}