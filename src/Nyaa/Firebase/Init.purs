module Nyaa.Firebase.Init where

import Effect (Effect)
import Nyaa.Firebase.Opaque (FirebaseAnalytics, FirebaseApp, FirebaseAuth, FirebaseFunctions, Firestore)

foreign import fbApp :: Effect FirebaseApp
foreign import fbAnalytics :: FirebaseApp -> Effect FirebaseAnalytics
foreign import fbDB :: FirebaseApp -> Effect Firestore
foreign import fbAuth :: FirebaseApp -> Effect FirebaseAuth
-- foreign import fbFunctions :: FirebaseApp -> Effect FirebaseFunctions