module Nyaa.Ionic.Alert (alert) where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toNullable)
import Effect (Effect)
import Effect.Aff (Aff)

foreign import alertImpl
  :: String
  -> Nullable String
  -> Nullable String
  -> Array { text :: String, handler :: Effect Unit } 
  -> Effect (Promise Unit)

alert :: String -> Maybe String -> Maybe String -> Array { text :: String, handler :: Effect Unit } -> Aff Unit
alert a b c d = toAffE $ alertImpl a (toNullable b) (toNullable c) d