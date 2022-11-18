module Nyaa.Custom.Pages.DazzleQuest where

import Effect.Ref as Ref
import Ocarina.WebAPI (AudioContext)

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

dazzleQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
dazzleQuest { audioContextRef } = questPage
  { name: "dazzle-quest"
  , title: "Unlock Dazzle!"
  , showFriend: true
  , audioContextRef
  , battleRoute: "/pro-level"
  }