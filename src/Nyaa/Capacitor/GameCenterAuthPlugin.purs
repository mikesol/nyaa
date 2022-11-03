module Nyaa.Capacitor.GameCenterAuthPlugin where


import Control.Promise (Promise)
import Effect (Effect)
import Nyaa.Firebase.Auth (SignInResult)

foreign import signInWithGameCenter :: Effect (Promise SignInResult)
