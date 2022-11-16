module Nyaa.Custom.Pages.DeityLevel where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.Game (game)
import Ocarina.WebAPI (AudioContext)

deityLevel :: { audioContext :: AudioContext, audioUri :: String } -> Effect Unit
deityLevel { audioContext, audioUri } = game
  { name: "deity-level"
  , audioContext
  , audioUri
  }
