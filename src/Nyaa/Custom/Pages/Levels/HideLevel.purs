module Nyaa.Custom.Pages.Levels.HideLevel where

import Prelude

import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Assets (lvl99URL)
import Nyaa.Charts.LVL99 (lvl99)
import Nyaa.Constants.Scores (hideScore)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

hideLevel
  :: { audioContextRef :: Ref.Ref AudioContext
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
hideLevel { audioContextRef, fxEvent, profile } = game
  { name: "hide-level"
  , quest: Hide
  , scoreToWin: hideScore
  , audioContextRef
  , audioUri: lvl99URL
  , fxEvent
  , profile
  , chart: lvl99
  , isTutorial: false
  }