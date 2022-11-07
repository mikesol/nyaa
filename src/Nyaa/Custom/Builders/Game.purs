module Nyaa.Custom.Builders.Game where

import Prelude

import Effect (Effect)
import Web.HTML (HTMLCanvasElement)

foreign import doThree :: HTMLCanvasElement -> Effect { start :: Effect Unit, stop :: Effect Unit, kill :: Effect Unit }
