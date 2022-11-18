module Nyaa.Custom.Pages.FlatQuest where

import Effect.Ref as Ref
import Ocarina.WebAPI (AudioContext)

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

flatQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
flatQuest { audioContextRef } = questPage
  { name: "flat-quest"
  , title: "Unlock Flat!"
  , showFriend: true
  , audioContextRef
  , battleRoute: "/newb-level"
  }