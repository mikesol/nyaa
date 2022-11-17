module Nyaa.Custom.Pages.DeityLevel where

import Prelude

import Effect (Effect)
import FRP.Event (EventIO)
import Nyaa.Custom.Builders.Game (FxData, game)
import Ocarina.WebAPI (AudioContext)

deityLevel
  :: { audioContext :: AudioContext
     , audioUri :: String
     , fxEvent :: EventIO FxData
     }
  -> Effect Unit
deityLevel { audioContext, audioUri, fxEvent } = game
  { name: "deity-level"
  , audioContext
  , audioUri
  , fxEvent
  }
