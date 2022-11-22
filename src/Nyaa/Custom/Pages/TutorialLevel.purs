module Nyaa.Custom.Pages.TutorialLevel where

import Prelude

import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Charts.Tutorial (tutorial)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Types.BattleRoute (BattleRoute(..))
import Ocarina.WebAPI (AudioContext)

tutorialLevel
  :: { audioContextRef :: Ref.Ref AudioContext
     , audioUri :: String
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
tutorialLevel { audioContextRef, audioUri, fxEvent, profile } = game
  { name: "tutorial-level"
  , audioContextRef
  , audioUri
  , fxEvent
  , profile
  , battleRoute: TutorialLevel
  , chart: tutorial
  , isTutorial: true
  }
