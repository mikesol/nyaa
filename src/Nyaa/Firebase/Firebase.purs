module Nyaa.Firebase.Firebase where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.Nullable (Nullable)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Ref as Ref
import Effect.Uncurried (EffectFn1)
import Nyaa.Capacitor.Preferences (getObject)
import Nyaa.Some (Some)

-- Auth
type User =
  { displayName :: Nullable String
  , email :: Nullable String
  , phoneNumber :: Nullable String
  , photoURL :: Nullable String
  , tenantId :: Nullable String
  , uid :: String
  }

foreign import gameCenterEagerAuth :: Effect (Promise Unit)
foreign import getCurrentUser :: Effect (Nullable User)
foreign import signInWithGameCenter :: Effect (Promise Unit)

foreign import signInWithPlayGames :: Effect (Promise Unit)

foreign import signInWithGoogle :: Effect (Promise Unit)
foreign import signOut :: Effect (Promise Unit)

foreign import listenToAuthStateChange
  :: EffectFn1 (Nullable User) Unit
  -> Effect (Effect Unit)

-- Firestore

type Profile' =
  ( avatarUrl :: String
  , username :: String
  , hasCompletedTutorial :: Boolean
  , track1 :: Boolean
  , flat :: Boolean
  , buzz :: Boolean
  , glide :: Boolean
  , back :: Boolean
  , track2 :: Boolean
  , rotate :: Boolean
  , hide :: Boolean
  , dazzle :: Boolean
  , track3 :: Boolean
  , crush :: Boolean
  , amplify :: Boolean
  , highScoreTrack1 :: Int
  , highScoreTrack2 :: Int
  , highScoreTrack3 :: Int
  )

newtype Profile = Profile (Some Profile')

derive instance Eq Profile
derive instance Newtype Profile _

foreign import getMeImpl
  :: (Profile -> Maybe Profile)
  -> (Maybe Profile)
  -> Effect (Promise (Maybe Profile))

getMe
  :: Effect (Promise (Maybe Profile))
getMe = getMeImpl Just Nothing

type CreateOrUpdateProfileAndInitializeListenerInput =
  { username :: Nullable String
  , avatarUrl :: Nullable String
  , hasCompletedTutorial :: Boolean
  , push :: EffectFn1 { profile :: Profile } Unit
  }

foreign import createOrUpdateProfileAndInitializeListener
  :: CreateOrUpdateProfileAndInitializeListenerInput
  -> Effect (Promise (Effect Unit))

reactToNewUser
  :: { push :: EffectFn1 { profile :: Profile } Unit
     , unsubProfileListener :: Ref.Ref (Effect Unit)
     , user :: Maybe User
     }
  -> Effect Unit
reactToNewUser { user, push, unsubProfileListener } = for_ user
  \usr -> launchAff_ do
    hct <- toAffE $ getObject "hasCompletedTutorial"
    unsub <- toAffE $ createOrUpdateProfileAndInitializeListener
      { username: usr.displayName
      , avatarUrl: usr.photoURL
      , hasCompletedTutorial: hct == Just "true"
      , push
      }
    liftEffect $ Ref.write unsub unsubProfileListener

foreign import updateName :: { username :: String } -> Effect (Promise Unit)
foreign import updateAvatarUrl :: { avatarUrl :: String } -> Effect (Promise Unit)
foreign import uploadAvatar :: Uint8Array -> Effect (Promise String)