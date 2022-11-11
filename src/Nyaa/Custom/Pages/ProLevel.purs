module Nyaa.Custom.Pages.ProLevel where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.Game (game)
import Ocarina.WebAPI (AudioContext)

proLevel :: { audioContext :: AudioContext } -> Effect Unit
proLevel { audioContext } = game
  { name: "pro-level"
  , audioContext
  }
