module Nyaa.Custom.Pages.Levels.TutorialLevel where

import Prelude

import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Assets (lvl99URL)
import Nyaa.Charts.Tutorial (tutorial)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

tutorialLevel
  :: { audioContextRef :: Ref.Ref AudioContext
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
tutorialLevel { audioContextRef, fxEvent, profile } = game
  { name: "tutorial-level"
  , audioContextRef
  , audioUri: lvl99URL
  , scoreToWin: -42
  , quest: Hypersynthetic
  , fxEvent
  , profile
  , chart: tutorial
  , isTutorial: true
  }
