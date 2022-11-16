module Nyaa.Custom.Pages.TutorialLevel where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.Game (game)
import Ocarina.WebAPI (AudioContext)

tutorialLevel :: { audioContext :: AudioContext, audioUri :: String } -> Effect Unit
tutorialLevel { audioContext, audioUri } = game
  { name: "tutorial-level"
  , audioContext
  , audioUri
  }
