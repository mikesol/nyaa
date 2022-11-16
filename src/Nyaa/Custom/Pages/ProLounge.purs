module Nyaa.Custom.Pages.ProLounge where

import Prelude

import Effect (Effect)
import FRP.Event (Event)
import Nyaa.Custom.Builders.Lounge (lounge)
import Nyaa.Firebase.Firebase (Profile)

proLounge :: { profileState :: Event { profile :: Profile } } -> Effect Unit
proLounge { profileState } = lounge
  { name: "pro-lounge"
  , title: "Show Me How"
  , profileState
  , missions: []
  }