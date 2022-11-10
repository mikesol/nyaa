module Nyaa.Capacitor.Preferences where

import Prelude

import Control.Promise (Promise)
import Data.Maybe (Maybe(..))
import Effect (Effect)

foreign import setObject :: String -> String -> Effect (Promise Unit)
foreign import getObjectImpl :: (String -> Maybe String) -> Maybe String -> String  -> Effect (Promise (Maybe String))
getObject :: String -> Effect (Promise (Maybe String))
getObject = getObjectImpl Just Nothing