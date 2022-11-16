module Nyaa.Ionic.Loading where

import Prelude

import Control.Promise (Promise, toAffE)
import Effect (Effect)
import Effect.Aff (Aff, Milliseconds(..), bracket, delay)

data Loading

foreign import presentLoading :: String -> Effect (Promise Loading)
foreign import dismissLoading :: Loading -> Effect (Promise Unit)

brackedWithLoading' :: Milliseconds -> String -> Aff ~> Aff
brackedWithLoading' n s a = bracket (toAffE $ presentLoading s)
  (\i -> do
    delay n
    toAffE $ dismissLoading i)
  \_ -> a

brackedWithLoading :: String -> Aff ~> Aff
brackedWithLoading = brackedWithLoading' (Milliseconds 0.0)