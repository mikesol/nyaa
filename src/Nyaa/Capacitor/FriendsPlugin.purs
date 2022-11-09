module Nyaa.Capacitor.FriendsPlugin where

import Prelude

import Control.Promise (Promise)
import Data.Nullable (Nullable)
import Effect (Effect)

newtype Friend = Friend
  { displayName :: String
  , alias :: String
  , avatar :: Nullable String
  , gamePlayerID :: Nullable String -- apple only
  , teamPlayerID :: Nullable String -- apple only
  }

foreign import sendFriendRequest :: Effect (Promise Unit)
foreign import getFriends :: Effect (Promise (Array Friend))