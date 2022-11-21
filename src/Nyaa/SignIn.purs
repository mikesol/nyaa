module Nyaa.SignIn where

import Prelude

import Control.Alt ((<|>))
import Control.Promise (toAffE)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, Milliseconds(..))
import Effect.Class (liftEffect)
import Nyaa.Capacitor.Utils (Platform(..), getPlatform)
import Nyaa.Firebase.Firebase (signInWithGoogle, signInWithGameCenter, signInWithPlayGames, signOut)
import Nyaa.Ionic.Alert (alert)
import Nyaa.Ionic.Loading (brackedWithLoading')

signInFlow :: Aff Unit
signInFlow = brackedWithLoading' (Milliseconds 400.0) "Signing in..."
  ( ( do
        platform <- liftEffect getPlatform
        case platform of
          Web -> void $ toAffE $ signInWithGoogle
          IOS -> void $ toAffE $ signInWithGameCenter
          Android -> void $ toAffE $ signInWithPlayGames
    ) <|>
      ( alert "Login Failed" Nothing (Just "Please try again later")
          [ { text: "OK", handler: pure unit } ]
      )
  )

signOutFlow :: { clearProfile :: Effect Unit } -> Aff Unit
signOutFlow i = do
  liftEffect i.clearProfile
  toAffE signOut