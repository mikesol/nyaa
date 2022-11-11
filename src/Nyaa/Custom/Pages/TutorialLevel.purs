module Nyaa.Custom.Pages.TutorialLevel where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.Game (game)
import Ocarina.WebAPI (AudioContext)

tutorialLevel :: { audioContext :: AudioContext } -> Effect Unit
tutorialLevel { audioContext } = game
  { name: "tutorial-level"
  , audioContext
  }
