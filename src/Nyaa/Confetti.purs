module Nyaa.Confetti where

import Prelude

import Effect (Effect)

foreign import addConfetti :: Effect Unit
