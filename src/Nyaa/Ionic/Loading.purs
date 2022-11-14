module Nyaa.Ionic.Loading where

import Prelude

import Control.Promise (Promise, toAffE)
import Effect (Effect)
import Effect.Aff (Aff, bracket)

data Loading

foreign import presentLoading :: String -> Effect (Promise Loading)
foreign import dismissLoading :: Loading -> Effect (Promise Unit)

brackedWithLoading :: String -> Aff ~> Aff
brackedWithLoading s a = bracket (toAffE $ presentLoading s)
  (toAffE <<< dismissLoading)
  \_ -> a