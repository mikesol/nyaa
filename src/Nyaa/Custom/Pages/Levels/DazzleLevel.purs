module Nyaa.Custom.Pages.Levels.DazzleLevel where

import Prelude

import Control.Promise (fromAff)
import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Assets (lvl99URL)
import Nyaa.Charts.LVL99 (lvl99)
import Nyaa.Constants.Scores (dazzleScore)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Custom.Pages.DevAdmin (dazzleEndgameRitual, doEndgameFailureRitual, doEndgameSuccessRitual)
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
  , backgroundName: "bg-lvl99"
  , fxEvent
  , profile
  , chart: lvl99
  , successPath: "/showmehow-quest"
  , failurePath: "/dazzle-quest"
  , successCb: map fromAff (doEndgameSuccessRitual dazzleEndgameRitual)
  , failureCb: map fromAff (doEndgameFailureRitual dazzleEndgameRitual)
  }