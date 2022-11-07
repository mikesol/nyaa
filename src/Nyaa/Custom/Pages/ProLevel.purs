module Nyaa.Custom.Pages.ProLevel where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.Game (game)

proLevel :: Effect Unit
proLevel = game
  { name: "pro-level"
  }