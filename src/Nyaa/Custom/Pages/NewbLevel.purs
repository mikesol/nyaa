module Nyaa.Custom.Pages.NewbLevel where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.Game (game)
import Ocarina.WebAPI (AudioContext)

newbLevel :: { audioContext :: AudioContext, audioUri :: String } -> Effect Unit
newbLevel { audioContext, audioUri } = game
  { name: "newb-level"
  , audioContext
  , audioUri
  }
