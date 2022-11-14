module Nyaa.SignIn where

import Prelude

import Control.Promise (toAffE)
import Effect.Aff (Aff, bracket)
import Effect.Class (liftEffect)
import Nyaa.Capacitor.Utils (Platform(..), getPlatform)
import Nyaa.Firebase.Firebase (signInWithGoogle, signInWithGameCenter, signInWithPlayGames, signOut)
import Nyaa.Ionic.Loading (dismissLoading, presentLoading)

signInFlow :: Aff Unit
signInFlow = bracket (toAffE $ presentLoading "Signing in...") (toAffE <<< dismissLoading) \_ -> do
  platform <- liftEffect getPlatform
  case platform of
    Web -> void $ toAffE $ signInWithGoogle
    IOS -> void $ toAffE $ signInWithGameCenter
    Android -> void $ toAffE $ signInWithPlayGames

signOutFlow :: Aff Unit
signOutFlow = toAffE signOut