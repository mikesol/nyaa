module Nyaa.Firebase.Auth where

import Prelude

import Control.Promise (Promise)
import Data.Nullable (Nullable)
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Nyaa.Firebase.Opaque (FirebaseAuth)

type User =
  { displayName :: Nullable String
  , email :: Nullable String
  , emailVerified :: Boolean
  , isAnonymous :: Boolean
  , phoneNumber :: Nullable String
  , photoURL :: Nullable String
  , providerId :: String
  , tenantId :: Nullable String
  , uid :: String
  }

type AuthCredential =
  { accessToken :: String
  , authorizationCode :: String
  , idToken :: String
  , nonce :: String
  , providerId :: String
  , secret :: String
  }

type SignInResult =
  { user :: Nullable User
  , credential :: Nullable AuthCredential
  , gamePlayerID :: Nullable String -- apple only
  , teamPlayerID :: Nullable String -- apple only
  }

foreign import getCurrentUser :: FirebaseAuth -> Effect (Promise { user :: Nullable User })
foreign import signInWithGameCenter :: FirebaseAuth -> Effect (Promise SignInResult)
foreign import signInWithGoogle :: FirebaseAuth ->Effect (Promise SignInResult)
foreign import signOut :: FirebaseAuth ->Effect (Promise Unit)
foreign import signInWithPlayGames :: FirebaseAuth ->Effect (Promise SignInResult)
foreign import listenToAuthStateChange
  :: FirebaseAuth -> EffectFn1 { user :: Nullable User } Unit -> Effect (Effect Unit)
