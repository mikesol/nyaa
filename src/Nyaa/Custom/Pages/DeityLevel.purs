module Nyaa.Custom.Pages.DeityLevel where

import Prelude

import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Charts.ShowMeHow (showMeHow)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Types.BattleRoute (BattleRoute(..))
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
  , chart: showMeHow
  , battleRoute: DeityLevel
  , isTutorial: false
  }
