module Nyaa.Custom.Pages.ProLevel where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.Game (game)
import Ocarina.WebAPI (AudioContext)

proLevel :: { audioContext :: AudioContext, audioUri :: String } -> Effect Unit
proLevel { audioContext, audioUri } = game
  { name: "pro-level"
  , audioContext
  , audioUri
  }
