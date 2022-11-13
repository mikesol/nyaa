module Nyaa.SignIn where

import Prelude

import Control.Promise (toAffE)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Nyaa.Capacitor.Utils (Platform(..), getPlatform)
import Nyaa.Firebase.Auth (signInWithGoogle, signInWithGameCenter, signInWithPlayGames, signOut)
import Nyaa.Firebase.Opaque (FirebaseAuth, FirebaseFunctions)

signInFlow :: { auth :: FirebaseAuth } -> Aff Unit
signInFlow { auth } = do
  platform <- liftEffect getPlatform
  case platform of
    Web -> void $ toAffE $ signInWithGoogle auth
    IOS -> void $ toAffE $ signInWithGameCenter auth
    Android -> void $ toAffE $ signInWithPlayGames auth

signOutFlow :: { auth :: FirebaseAuth } -> Aff Unit
signOutFlow { auth }=  toAffE$ signOut auth