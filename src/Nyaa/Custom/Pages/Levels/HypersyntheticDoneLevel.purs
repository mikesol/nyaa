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
  , fxEvent
  , profile
  , chart: hypersynthetic
  , successPath: "/lounge-picker"
  , failurePath: "/lounge-picker"
  , successCb: \_ -> fromAff (pure unit)
  , failureCb: \_ -> fromAff (pure unit)
  }
