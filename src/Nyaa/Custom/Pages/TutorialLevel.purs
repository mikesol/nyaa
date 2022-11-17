module Nyaa.Custom.Pages.TutorialLevel where

import Prelude

import Effect (Effect)
import FRP.Event (EventIO)
import Nyaa.Custom.Builders.Game (FxData, game)
import Ocarina.WebAPI (AudioContext)

tutorialLevel
  :: { audioContext :: AudioContext
     , audioUri :: String
     , fxEvent :: EventIO FxData
     }
  -> Effect Unit
tutorialLevel { audioContext, audioUri, fxEvent } = game
  { name: "tutorial-level"
  , audioContext
  , audioUri
  , fxEvent
  }
