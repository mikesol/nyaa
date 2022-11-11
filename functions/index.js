const functions = require('firebase-functions');

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();
const auth = admin.auth();

exports.customAuth = functions.https.onRequest(async (req, res) => {
    const idToken = req.body.idToken;
    const decodedToken = await auth.verifyIdToken(idToken);
    const result = await auth.createCustomToken(decodedToken.uid);
    res.json({ result });
  });