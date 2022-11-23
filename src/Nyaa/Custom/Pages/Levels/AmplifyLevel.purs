module Nyaa.Custom.Pages.Levels.AmplifyLevel where

import Prelude

import Control.Promise (fromAff)
import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Assets (showMeHowURL)
import Nyaa.Charts.ShowMeHow (showMeHow)
import Nyaa.Constants.Scores (amplifyScore)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Custom.Pages.DevAdmin (amplifyEndgameRitual, doEndgameSuccessRitual, doEndgameFailureRitual)
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
  , successPath: "/you-won"
  , failurePath: "/amplify-quest"
  , successCb: map fromAff (doEndgameSuccessRitual amplifyEndgameRitual)
  , failureCb: map fromAff (doEndgameFailureRitual amplifyEndgameRitual)
  }
