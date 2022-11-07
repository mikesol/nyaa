module Nyaa.Custom.Pages.DeityLounge where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.Lounge (lounge)

deityLounge :: Effect Unit
deityLounge = lounge
  { name: "deity-lounge"
  , title: "Deity Lounge"
  , img: ""
  , text: "hi"
  , next: pure unit
  }