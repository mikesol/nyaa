module Nyaa.Util.RandomId where

import Effect (Effect)

foreign import makeId :: Int -> Effect String