module Nyaa.Custom.Pages.Levels.BackLevel where

import Prelude

import Control.Promise (fromAff)
import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Assets (lvl99URL)
import Nyaa.Charts.Hypersynthetic (hypersynthetic)
import Nyaa.Constants.Scores (backScore)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Custom.Pages.DevAdmin (backEndgameRitual, doEndgameFailureRitual, doEndgameSuccessRitual)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

backLevel
  :: { audioContextRef :: Ref.Ref AudioContext
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
backLevel { audioContextRef, fxEvent, profile } = game
  { name: "back-level"
  , quest: Back
  , scoreToWin: backScore
  , audioContextRef
  , audioUri: lvl99URL -- change!!
  , fxEvent
  , profile
  , chart: hypersynthetic
  , successPath: "/lvlnn-quest"
  , failurePath: "/back-quest"
  , successCb: map fromAff (doEndgameSuccessRitual backEndgameRitual)
  , failureCb: map fromAff (doEndgameFailureRitual backEndgameRitual)
  }