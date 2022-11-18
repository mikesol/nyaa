module Nyaa.Custom.Pages.ProLevel where

import Prelude

import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Charts.ShowMeHow (showMeHow)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Firebase.Firebase (Profile)
import Ocarina.WebAPI (AudioContext)

proLevel :: { audioContextRef :: Ref.Ref AudioContext
     , audioUri :: String
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
proLevel { audioContextRef, audioUri, fxEvent, profile } = game
  { name: "pro-level"
  , audioContextRef
  , audioUri
  , fxEvent
  , profile
  , chart: showMeHow
  , isTutorial: false
  }