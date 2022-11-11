module Nyaa.Custom.Pages.DeityLevel where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.Game (game)
import Ocarina.WebAPI (AudioContext)

deityLevel :: { audioContext :: AudioContext } -> Effect Unit
deityLevel { audioContext } = game
  { name: "deity-level"
  , audioContext
  }
