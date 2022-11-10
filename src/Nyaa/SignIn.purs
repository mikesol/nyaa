module Nyaa.SignIn where

import Prelude

import Control.Promise (toAffE)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Nyaa.Capacitor.Utils (Platform(..), getPlatform)
import Nyaa.Firebase.Auth (signInWithGoogle, signInWithGameCenter, signInWithPlayGames, signOut)

signInFlow :: Aff Unit
signInFlow = do
  platform <- liftEffect getPlatform
  case platform of
    Web -> void $ toAffE signInWithGoogle
    IOS -> void $ toAffE signInWithGameCenter
    Android -> void $ toAffE signInWithPlayGames

signOutFlow :: Aff Unit
signOutFlow =  toAffE signOut