module Nyaa.Firebase.Firestore where

import Prelude

import Control.Promise (Promise, toAffE)
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
import Nyaa.Firebase.Auth (User)
import Nyaa.Firebase.Opaque (FirebaseAuth, Firestore)
import Nyaa.Some (Some)

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
derive instance  Newtype Profile _

foreign import getMeImpl
  :: (Profile -> Maybe Profile)
  -> (Maybe Profile)
  -> Firestore
  -> FirebaseAuth
  -> Effect (Promise (Maybe Profile))

getMe
  :: Firestore
  -> FirebaseAuth
  -> Effect (Promise (Maybe Profile))
getMe = getMeImpl Just Nothing

type CreateOrUpdateProfileAndInitializeListenerInput =
  { db :: Firestore
  , uid :: String
  , username :: Nullable String
  , avatarUrl :: Nullable String
  , hasCompletedTutorial :: Boolean
  , push :: EffectFn1 { profile :: Profile } Unit
  }

foreign import createOrUpdateProfileAndInitializeListener
  :: CreateOrUpdateProfileAndInitializeListenerInput
  -> Effect (Promise (Effect Unit))

reactToNewUser
  :: { firestoreDB :: Firestore
     , push :: EffectFn1 { profile :: Profile } Unit
     , unsubProfileListener :: Ref.Ref (Effect Unit)
     , user :: Maybe User
     }
  -> Effect Unit
reactToNewUser { user, firestoreDB, push, unsubProfileListener } = for_ user
  \usr -> launchAff_ do
    hct <- toAffE $ getObject "hasCompletedTutorial"
    unsub <- toAffE $ createOrUpdateProfileAndInitializeListener
      { db: firestoreDB
      , uid: usr.uid
      , username: usr.displayName
      , avatarUrl: usr.photoURL
      , hasCompletedTutorial: hct == Just "true"
      , push
      }
    liftEffect $ Ref.write unsub unsubProfileListener