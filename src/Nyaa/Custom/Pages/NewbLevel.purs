module Nyaa.Custom.Pages.NewbLevel where

import Prelude

import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Charts.Hypersynthetic (hypersynthetic)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Firebase.Firebase (Profile)
import Ocarina.WebAPI (AudioContext)

newbLevel
  :: { audioContextRef :: Ref.Ref AudioContext
     , audioUri :: String
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
newbLevel { audioContextRef, audioUri, fxEvent, profile } = game
  { name: "newb-level"
  , audioContextRef
  , audioUri
  , fxEvent
  , profile
  , chart: hypersynthetic
  , isTutorial: false
  }