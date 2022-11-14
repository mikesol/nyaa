module Nyaa.Firebase.Firebase where

import Prelude

import Data.Nullable (Nullable)
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Control.Promise (Promise, toAffE)
import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Ref as Ref
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
  , quest1 :: Boolean
  , quest2 :: Boolean
  , quest3 :: Boolean
  , quest4 :: Boolean
  , quest5 :: Boolean
  , quest6 :: Boolean
  , quest7 :: Boolean
  , quest8 :: Boolean
  , quest9 :: Boolean
  , questNya :: Boolean
  , questNyaa :: Boolean
  , questNyaaa :: Boolean
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