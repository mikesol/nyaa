module Nyaa.Custom.Pages.Levels.GlideLevel where

import Prelude

import Control.Promise (fromAff)
import Effect (Effect)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO)
import Nyaa.Assets (lvl99URL)
import Nyaa.Charts.Hypersynthetic (hypersynthetic)
import Nyaa.Constants.Scores (glideScore)
import Nyaa.Custom.Builders.Game (FxData, game)
import Nyaa.Custom.Pages.DevAdmin (doEndgameFailureRitual, doEndgameSuccessRitual, glideEndgameRitual)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

glideLevel
  :: { audioContextRef :: Ref.Ref AudioContext
     , fxEvent :: EventIO FxData
     , profile :: Event Profile
     }
  -> Effect Unit
glideLevel { audioContextRef, fxEvent, profile } = game
  { name: "glide-level"
  , quest: Glide
  , scoreToWin: glideScore
  , audioContextRef
  , audioUri: lvl99URL -- change!!
  , fxEvent
  , profile
  , chart: hypersynthetic
  , successPath: "/back-quest"
  , failurePath: "/glide-quest"
  , successCb: map fromAff (doEndgameSuccessRitual glideEndgameRitual)
  , failureCb: map fromAff (doEndgameFailureRitual glideEndgameRitual)
  }