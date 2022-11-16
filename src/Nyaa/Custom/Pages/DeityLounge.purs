module Nyaa.Custom.Pages.DeityLounge where

import Prelude

import Effect (Effect)
import FRP.Event (Event)
import Nyaa.Custom.Builders.Lounge (lounge)
import Nyaa.Firebase.Firebase (Profile)

deityLounge :: { profileState :: Event { profile :: Profile } } -> Effect Unit
deityLounge { profileState } = lounge
  { name: "deity-lounge"
  , title: "LVL.99"
  , profileState
  , missions: []
  }