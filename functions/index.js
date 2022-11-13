const functions = require("firebase-functions");
const verifier = require("gamecenter-identity-verifier");
const admin = require("firebase-admin");
const cors = require("cors")({origin: true});

admin.initializeApp();
const auth = admin.auth();

const BUNDLE_ID = "fm.joyride.nyaa";

exports.gcAuth = functions.https.onRequest((req, res) => {
  return cors(req, res, async () => {
    const info = req.body;
    const identity = {
      publicKeyUrl: info.publicKeyURL,
      timestamp: parseInt(info.timestamp),
      signature: info.signature,
      salt: info.salt,
      playerId: info.teamPlayerID,
      bundleId: BUNDLE_ID,
    };
    await new Promise((resolve, reject) => {
      verifier.verify(identity, function(err) {
        if (err) {
          reject(err);
          return;
        }
        resolve();
      });
    });
    // super important that this is the game player id, NOT the team player id!
    const result = await auth.createCustomToken(info.gamePlayerID);
    res.json({result});
  });
});
