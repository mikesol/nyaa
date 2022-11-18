module Nyaa.Custom.Pages.TutorialLevel where

import Prelude

import Effect (Effect)
import FRP.Event (Event, EventIO)
import Nyaa.Charts.Tutorial (tutorial)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Firebase.Firebase (Profile)
import Ocarina.WebAPI (AudioContext)

tutorialLevel
  :: { audioContext :: AudioContext
     , audioUri :: String
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
tutorialLevel { audioContext, audioUri, fxEvent, profile } = game
  { name: "tutorial-level"
  , audioContext
  , audioUri
  , fxEvent
  , profile
  , chart: tutorial
  }
