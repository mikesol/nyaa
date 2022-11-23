module Nyaa.Custom.Pages.Levels.Lvl99Level where

import Prelude

import Control.Promise (fromAff)
import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Assets (lvl99URL)
import Nyaa.Charts.Hypersynthetic (hypersynthetic)
import Nyaa.Constants.Scores (track2Score)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Custom.Pages.DevAdmin (doEndgameFailureRitual, doEndgameSuccessRitual, track2EndgameRitual)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

lvl99Level
  :: { audioContextRef :: Ref.Ref AudioContext
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
lvl99Level { audioContextRef, fxEvent, profile } = game
  { name: "lvlnn-level"
  , quest: Lvl99
  , scoreToWin: track2Score
  , audioContextRef
  , audioUri: lvl99URL
  , fxEvent
  , profile
  , chart: hypersynthetic
  , successPath: "/rotate-quest"
  , failurePath: "/lvlnn-quest"
  , successCb: map fromAff (doEndgameSuccessRitual track2EndgameRitual)
  , failureCb: map fromAff (doEndgameFailureRitual track2EndgameRitual)
  }