module Nyaa.Custom.Pages.Levels.EqualizeLevel where

import Prelude

import Control.Promise (fromAff)
import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Assets (hypersyntheticURL)
import Nyaa.Charts.Hypersynthetic (hypersynthetic)
import Nyaa.Constants.Scores (equalizeScore)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Custom.Pages.DevAdmin (doEndgameFailureRitual, doEndgameSuccessRitual, flatEndgameRitual)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

equalizeLevel
  :: { audioContextRef :: Ref.Ref AudioContext
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
equalizeLevel { audioContextRef, fxEvent, profile } = game
  { name: "equalize-level"
  , quest: Equalize
  , scoreToWin: equalizeScore
  , audioContextRef
  , audioUri: hypersyntheticURL
  , backgroundName: "bg-hypersynthetic"
  , fxEvent
  , profile
  , chart: hypersynthetic
  , successPath: "/buzz-quest"
  , failurePath: "/flat-quest"
  , successCb: map fromAff (doEndgameSuccessRitual flatEndgameRitual)
  , failureCb: map fromAff (doEndgameFailureRitual flatEndgameRitual)
  }