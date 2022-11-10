module Nyaa.Custom.Pages.TutorialLevel where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.Game (game)

tutorialLevel :: Effect Unit
tutorialLevel = game
  { name: "tutorial-level"
  }