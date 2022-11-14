module Nyaa.Ionic.Loading where

import Prelude

import Control.Promise (Promise)
import Effect (Effect)

data Loading

foreign import presentLoading :: String -> Effect (Promise Loading)
foreign import dismissLoading :: Loading -> Effect (Promise Unit)