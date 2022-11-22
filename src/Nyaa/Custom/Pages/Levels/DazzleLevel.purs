module Nyaa.Custom.Pages.Levels.DazzleLevel where

import Prelude

import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Assets (lvl99URL)
import FRP.Event (Event, EventIO)
import Nyaa.Charts.LVL99 (lvl99)
import Nyaa.Constants.Scores (dazzleScore)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

dazzleLevel
  :: { audioContextRef :: Ref.Ref AudioContext
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
dazzleLevel { audioContextRef, fxEvent, profile } = game
  { name: "dazzle-level"
  , quest: Dazzle
  , scoreToWin: dazzleScore
  , audioContextRef
  , audioUri: lvl99URL
  , fxEvent
  , profile
  , chart: lvl99
  , isTutorial: false
  }