module Nyaa.Custom.Pages.DeityLevel where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.Game (game)

deityLevel :: Effect Unit
deityLevel = game
  { name: "deity-level"
  }