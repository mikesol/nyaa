module Nyaa.Custom.Pages.Levels.ShowMeHowLevel where

import Prelude

import Control.Promise (fromAff)
import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Assets (lvl99URL)
import Nyaa.Charts.LVL99 (lvl99)
import Nyaa.Constants.Scores (track3Score)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Custom.Pages.DevAdmin (doEndgameFailureRitual, doEndgameSuccessRitual, track3EndgameRitual)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

showMeHowLevel
  :: { audioContextRef :: Ref.Ref AudioContext
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
showMeHowLevel { audioContextRef, fxEvent, profile } = game
  { name: "showmehow-level"
  , quest: ShowMeHow
  , scoreToWin: track3Score
  , audioContextRef
  , audioUri: lvl99URL
  , fxEvent
  , profile
  , chart: lvl99
  , successPath: "/crush-quest"
  , failurePath: "/showmehow-quest"
  , successCb: map fromAff (doEndgameSuccessRitual track3EndgameRitual)
  , failureCb: map fromAff (doEndgameFailureRitual track3EndgameRitual)
  }