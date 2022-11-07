module Nyaa.Custom.Pages.NewbLounge where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.Lounge (lounge)

newbLounge :: Effect Unit
newbLounge = lounge
  { name: "newb-lounge"
  , title: "Newb Lounge"
  , img: ""
  , text: "hi"
  , next: pure unit
  }