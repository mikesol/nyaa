const functions = require("firebase-functions");
const verifier = require("gamecenter-identity-verifier");
const {defineSecret} = require("firebase-functions/params");
const admin = require("firebase-admin");
const cors = require("cors")({origin: true});
const {google} = require("googleapis");

const nyaaServerClientId = defineSecret("NYAA_SERVER_CLIENT_ID");
const nyaaServerClientSecret = defineSecret("NYAA_SERVER_CLIENT_SECRET");

admin.initializeApp();
const auth = admin.auth();

const BUNDLE_ID = "fm.joyride.nyaa";

exports.pgAuth = functions
    .runWith({secrets: [nyaaServerClientId, nyaaServerClientSecret,
      // nyaaClientClientId, nyaaClientClientSecret
    ]})
    .https.onRequest((req, res) => {
      return cors(req, res, async () => {
        functions.logger.info("auth",
            {cli: nyaaServerClientId.value(),
              sec: nyaaServerClientSecret.value()});
        const oauth2Client = new google.auth.OAuth2(
            nyaaServerClientId.value(),
            nyaaServerClientSecret.value(),
            "https://nyaa-game.firebaseapp.com/__/auth/handler",
        );
        await oauth2Client.getToken(req.body.code);
        // we need to revoke the token immediately,
        // otherwise the client raises
        // com.google.firebase.auth.FirebaseAuthUserCollisionException:
        // This credential is already associated with a different user account.
        // await oauth2Client.revokeToken(tokenRes.tokens.access_token);
        const result =
          await auth.createCustomToken(req.body.playerId);
        res.json({result});
      });
    });

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
