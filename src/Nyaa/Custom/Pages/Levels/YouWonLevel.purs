module Nyaa.Custom.Pages.Levels.YouWonLevel where

import Prelude

import Control.Promise (fromAff)
import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Assets (showMeHowURL)
import Nyaa.Charts.ShowMeHow (showMeHow)
import Nyaa.Constants.Scores (amplifyScore)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Custom.Pages.DevAdmin (amplifyEndgameRitual, doScoreOnlyRitual, endgameRitualToScoreOnly)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

youwonLevel
  :: { audioContextRef :: Ref.Ref AudioContext
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
youwonLevel { audioContextRef, fxEvent, profile } = game
  { name: "youwon-level"
  , quest: YouWon
  , scoreToWin: amplifyScore
  , audioContextRef
  , audioUri: showMeHowURL
  , backgroundName: "bg-showmehow"
  , fxEvent
  , profile
  , chart: showMeHow
  , successPath: "/youwon-quest"
  , failurePath: "/youwon-quest"
  , successCb: map fromAff (doScoreOnlyRitual (endgameRitualToScoreOnly amplifyEndgameRitual))
  , failureCb: map fromAff (doScoreOnlyRitual (endgameRitualToScoreOnly amplifyEndgameRitual))
  }
