module Nyaa.Custom.Pages.NewbLevel where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.Game (game)

newbLevel :: Effect Unit
newbLevel = game
  { name: "newb-level"
  }