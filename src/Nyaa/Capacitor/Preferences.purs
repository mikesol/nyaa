module Nyaa.Capacitor.Preferences where

import Prelude

import Control.Promise (Promise)
import Data.Maybe (Maybe(..))
import Effect (Effect)

foreign import setPreference :: String -> String -> Effect (Promise Unit)
foreign import getPreferenceImpl
  :: (String -> Maybe String)
  -> Maybe String
  -> String
  -> Effect (Promise (Maybe String))

getPreference :: String -> Effect (Promise (Maybe String))
getPreference = getPreferenceImpl Just Nothing