module Nyaa.Custom.Pages.Levels.Lvl99DoneLevel where

import Prelude

import Control.Promise (fromAff)
import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Assets (lvl99URL)
import Nyaa.Charts.LVL99 (lvl99)
import Nyaa.Constants.Scores (amplifyScore)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

lvl99DoneLevel
  :: { audioContextRef :: Ref.Ref AudioContext
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
lvl99DoneLevel { audioContextRef, fxEvent, profile } = game
  { name: "lvlnndone-level"
  , quest: BeatLvl99
  , scoreToWin: amplifyScore
  , audioContextRef
  , audioUri: lvl99URL
  , backgroundName: "bg-lvl99"
  , fxEvent
  , profile
  , chart: lvl99
  , successPath: "/lounge-picker"
  , failurePath: "/lounge-picker"
  , successCb: \_ -> fromAff (pure unit)
  , failureCb: \_ -> fromAff (pure unit)
  }
