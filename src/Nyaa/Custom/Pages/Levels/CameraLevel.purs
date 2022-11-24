module Nyaa.Custom.Pages.Levels.CameraLevel where

import Prelude

import Control.Promise (fromAff)
import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Assets (hypersyntheticURL)
import Nyaa.Charts.Hypersynthetic (hypersynthetic)
import Nyaa.Constants.Scores (cameraScore)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Custom.Pages.DevAdmin (doEndgameSuccessRitual, doEndgameFailureRitual, buzzEndgameRitual)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

cameraLevel
  :: { audioContextRef :: Ref.Ref AudioContext
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
cameraLevel { audioContextRef, fxEvent, profile } = game
  { name: "camera-level"
  , scoreToWin: cameraScore
  , quest: Camera
  , audioContextRef
  , audioUri: hypersyntheticURL
  , backgroundName: "bg-hypersynthetic"
  , fxEvent
  , profile
  , chart: hypersynthetic
  , successPath: "/glide-quest"
  , failurePath: "/buzz-quest"
  , successCb: map fromAff (doEndgameSuccessRitual buzzEndgameRitual)
  , failureCb: map fromAff (doEndgameFailureRitual buzzEndgameRitual)
  }