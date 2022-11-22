module Nyaa.Custom.Pages.Levels.GlideLevel where

import Prelude

import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Assets (lvl99URL)
import FRP.Event (Event, EventIO)
import Nyaa.Charts.Hypersynthetic (hypersynthetic)
import Nyaa.Constants.Scores (glideScore)
import Nyaa.Custom.Builders.Game (FxData, game)
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
  , isTutorial: false
  }