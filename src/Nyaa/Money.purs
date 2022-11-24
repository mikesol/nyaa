module Nyaa.Money where

import Prelude

import Control.Promise (Promise)
import Effect (Effect)

foreign import buy :: Effect Unit -> Effect Unit -> Effect Unit
foreign import refreshStatus :: Effect (Promise Unit)