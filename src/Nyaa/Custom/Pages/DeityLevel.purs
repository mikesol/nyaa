module Nyaa.Custom.Pages.DeityLevel where

import Prelude

import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Charts.LVL99 (lvl99)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Firebase.Firebase (Profile)
import Ocarina.WebAPI (AudioContext)

deityLevel
  :: { audioContextRef :: Ref.Ref AudioContext
     , audioUri :: String
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
deityLevel { audioContextRef, audioUri, fxEvent, profile } = game
  { name: "deity-level"
  , audioContextRef
  , audioUri
  , fxEvent
  , profile
  , chart: lvl99
  , isTutorial: false
  }
