module Nyaa.Money where

import Prelude

import Effect (Effect)

foreign import buy :: Effect Unit -> Effect Unit -> Effect Unit
