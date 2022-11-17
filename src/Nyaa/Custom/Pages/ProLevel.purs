module Nyaa.Custom.Pages.ProLevel where

import Prelude

import Effect (Effect)
import FRP.Event (Event, EventIO)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Firebase.Firebase (Profile)
import Ocarina.WebAPI (AudioContext)

proLevel :: { audioContext :: AudioContext
     , audioUri :: String
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
proLevel { audioContext, audioUri, fxEvent, profile } = game
  { name: "pro-level"
  , audioContext
  , audioUri
  , fxEvent
  , profile
  }