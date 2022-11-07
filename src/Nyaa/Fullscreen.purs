module Nyaa.Fullscreen where

import Prelude

import Control.Promise (Promise)
import Effect (Effect)

foreign import androidFullScreen :: Effect (Promise Unit)