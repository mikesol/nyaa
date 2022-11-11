module Nyaa.Custom.Pages.NewbLevel where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.Game (game)
import Ocarina.WebAPI (AudioContext)

newbLevel :: { audioContext :: AudioContext } -> Effect Unit
newbLevel { audioContext } = game
  { name: "newb-level"
  , audioContext
  }
