module Nyaa.Custom.Pages.RotateQuest where

import Effect.Ref as Ref
import Ocarina.WebAPI (AudioContext)

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

rotateQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
rotateQuest { audioContextRef } = questPage
  { name: "rotate-quest"
  , title: "Unlock Rotate!"
  , showFriend: true
  , audioContextRef
  , battleRoute: "/pro-level"
  }