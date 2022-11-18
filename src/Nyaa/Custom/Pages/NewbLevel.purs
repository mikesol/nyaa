module Nyaa.Custom.Pages.NewbLevel where

import Prelude

import Effect (Effect)
import FRP.Event (Event, EventIO)
import Nyaa.Charts.Hypersynthetic (hypersynthetic)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Firebase.Firebase (Profile)
import Ocarina.WebAPI (AudioContext)

newbLevel
  :: { audioContext :: AudioContext
     , audioUri :: String
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
newbLevel { audioContext, audioUri, fxEvent, profile } = game
  { name: "newb-level"
  , audioContext
  , audioUri
  , fxEvent
  , profile
  , chart: hypersynthetic
  }