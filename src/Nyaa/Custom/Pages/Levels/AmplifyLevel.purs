module Nyaa.Custom.Pages.Levels.AmplifyLevel where

import Prelude

import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Assets (showMeHowURL)
import Nyaa.Charts.ShowMeHow (showMeHow)
import Nyaa.Constants.Scores (amplifyScore)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

amplifyLevel
  :: { audioContextRef :: Ref.Ref AudioContext
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
amplifyLevel { audioContextRef, fxEvent, profile } = game
  { name: "amplify-level"
  , quest: Amplify
  , scoreToWin: amplifyScore
  , audioContextRef
  , audioUri: showMeHowURL
  , fxEvent
  , profile
  , chart: showMeHow
  , isTutorial: false
  }
