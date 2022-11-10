module Nyaa.Firebase.Firestore where

import Prelude

import Control.Promise (Promise)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
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

foreign import getMeImpl
  :: (Profile -> Maybe Profile)
  -> (Maybe Profile)
  -> FirebaseAuth
  -> Effect (Promise (Maybe Profile))

getMe
  :: FirebaseAuth
  -> Effect (Promise (Maybe Profile))
getMe = getMeImpl Just Nothing

type CreataeOrUpdateProfileAndInitializeListenerInput =
  { db :: Firestore
  , uid :: String
  , username :: String
  , avatarUrl :: String
  , hasCompletedTutorial :: Boolean
  , push :: EffectFn1 Profile Unit
  }

foreign import creataeOrUpdateProfileAndInitializeListener
  :: CreataeOrUpdateProfileAndInitializeListenerInput
  -> Effect (Promise (Effect Unit))
