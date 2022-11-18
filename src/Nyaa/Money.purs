module Nyaa.Money where

import Prelude

import Effect (Effect)

foreign import registerPaidSong :: Effect Unit
foreign import buy :: Effect Unit -> Effect Unit -> Effect Unit
foreign import isOwned :: Effect Boolean