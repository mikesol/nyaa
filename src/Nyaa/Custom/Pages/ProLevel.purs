module Nyaa.Custom.Pages.ProLevel where

import Prelude

import Effect (Effect)
import FRP.Event (EventIO)
import Nyaa.Custom.Builders.Game (FxData, game)
import Ocarina.WebAPI (AudioContext)

proLevel :: { audioContext :: AudioContext
     , audioUri :: String
     , fxEvent :: EventIO FxData
     }
  -> Effect Unit
proLevel { audioContext, audioUri, fxEvent } = game
  { name: "pro-level"
  , audioContext
  , audioUri
  , fxEvent
  }