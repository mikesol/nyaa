module Nyaa.Custom.Pages.ProLounge where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.Lounge (lounge)

proLounge :: Effect Unit
proLounge = lounge
  { name: "pro-lounge"
  , title: "Pro Lounge"
  , img: ""
  , text: "hi"
  , next: pure unit
  }