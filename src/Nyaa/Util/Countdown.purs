module Nyaa.Util.Countdown where

import Prelude

import Effect (Effect)

----------- n times - do something - cooldown - start/stop
foreign import countdown
  :: Number
  -> Int
  -> (Int -> Effect Unit)
  -> Effect Unit
  -> Effect (Effect Unit)