module Nyaa.Custom.Pages.CrushQuest where

import Effect.Ref as Ref
import Ocarina.WebAPI (AudioContext)

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

crushQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
crushQuest { audioContextRef } = questPage
  { name: "crush-quest"
  , title: "Unlock Crush!"
  , showFriend: true
  , audioContextRef
  , battleRoute: "/deity-level"
  }