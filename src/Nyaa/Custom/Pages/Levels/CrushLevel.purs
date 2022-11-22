module Nyaa.Custom.Pages.Levels.CrushLevel where

import Prelude

import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Assets (showMeHowURL)
import Nyaa.Charts.ShowMeHow (showMeHow)
import Nyaa.Constants.Scores (crushScore)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

crushLevel
  :: { audioContextRef :: Ref.Ref AudioContext
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
crushLevel { audioContextRef, fxEvent, profile } = game
  { name: "crush-level"
  , scoreToWin: crushScore
  , quest: Audio
  , audioContextRef
  , audioUri: showMeHowURL
  , fxEvent
  , profile
  , chart: showMeHow
  , isTutorial: false
  }
