module Nyaa.Custom.Pages.BackQuest where

import Effect.Ref as Ref
import Ocarina.WebAPI (AudioContext)

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

backQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
backQuest { audioContextRef } = questPage
  { name: "back-quest"
  , title: "Unlock Back!"
  , showFriend: true
  , audioContextRef
  , battleRoute: "/newb-level"
  }