module Nyaa.Custom.Pages.HideQuest where

import Effect.Ref as Ref
import Ocarina.WebAPI (AudioContext)

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

hideQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
hideQuest { audioContextRef } = questPage
  { name: "hide-quest"
  , title: "Unlock Hide!"
  , showFriend: true
  , audioContextRef
  , battleRoute: "/pro-level"
  }