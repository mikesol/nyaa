module Nyaa.Custom.Pages.NewbLevel where

import Prelude

import Effect (Effect)
import FRP.Event (EventIO)
import Nyaa.Custom.Builders.Game (FxData, game)
import Ocarina.WebAPI (AudioContext)

newbLevel :: { audioContext :: AudioContext
     , audioUri :: String
     , fxEvent :: EventIO FxData
     }
  -> Effect Unit
newbLevel { audioContext, audioUri, fxEvent } = game
  { name: "newb-level"
  , audioContext
  , audioUri
  , fxEvent
  }