module Nyaa.Custom.Pages.Levels.HypersyntheticDoneLevel where

import Prelude

import Control.Promise (fromAff)
import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Assets (hypersyntheticURL)
import Nyaa.Charts.Hypersynthetic (hypersynthetic)
import Nyaa.Constants.Scores (amplifyScore)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Custom.Pages.DevAdmin (doScoreOnlyRitual, endgameRitualToScoreOnly, track2EndgameRitual)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

hypersyntheticDoneLevel
  :: { audioContextRef :: Ref.Ref AudioContext
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
hypersyntheticDoneLevel { audioContextRef, fxEvent, profile } = game
  { name: "hypersyntheticdone-level"
  , quest: BeatHypersynthetic
  , scoreToWin: amplifyScore
  , audioContextRef
  , audioUri: hypersyntheticURL
  , backgroundName: "bg-hypersynthetic"
  , fxEvent
  , profile
  , chart: hypersynthetic
  , successPath: "/lounge-picker"
  , failurePath: "/lounge-picker"
  , successCb: map fromAff (doScoreOnlyRitual (endgameRitualToScoreOnly track2EndgameRitual))
  , failureCb: map fromAff (doScoreOnlyRitual (endgameRitualToScoreOnly track2EndgameRitual))
  }
