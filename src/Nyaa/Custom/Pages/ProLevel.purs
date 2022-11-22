module Nyaa.Custom.Pages.ProLevel where

import Prelude

import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Charts.LVL99 (lvl99)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Types.BattleRoute (BattleRoute(..))
import Ocarina.WebAPI (AudioContext)

proLevel
  :: { audioContextRef :: Ref.Ref AudioContext
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
  , chart: lvl99
  , battleRoute: ProLevel
  , isTutorial: false
  }