module Nyaa.Custom.Pages.Levels.CameraLevel where

import Prelude

import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Assets (lvl99URL)
import Nyaa.Charts.Hypersynthetic (hypersynthetic)
import Nyaa.Constants.Scores (cameraScore)
import Nyaa.Custom.Builders.Game (FxData, game)
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
  , audioUri: lvl99URL -- change!!
  , fxEvent
  , profile
  , chart: hypersynthetic
  , isTutorial: false
  }