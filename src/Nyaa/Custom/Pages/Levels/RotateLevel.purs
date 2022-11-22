module Nyaa.Custom.Pages.Levels.RotateLevel where

import Prelude

import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Assets (lvl99URL)
import Nyaa.Charts.LVL99 (lvl99)
import Nyaa.Constants.Scores (rotateScore)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

rotateLevel
  :: { audioContextRef :: Ref.Ref AudioContext
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
rotateLevel { audioContextRef, fxEvent, profile } = game
  { name: "rotate-level"
  , quest: Rotate
  , scoreToWin: rotateScore
  , audioContextRef
  , audioUri: lvl99URL
  , fxEvent
  , profile
  , chart: lvl99
  , isTutorial: false
  }