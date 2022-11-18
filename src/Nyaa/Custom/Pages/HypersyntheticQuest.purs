module Nyaa.Custom.Pages.HypersyntheticQuest where

import Effect.Ref as Ref
import Ocarina.WebAPI (AudioContext)

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

hypersyntheticQuest
  :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
hypersyntheticQuest { audioContextRef } = questPage
  { name: "hypersynthetic-quest"
  , title: "Unlock HYPERSYNTHETIC!"
  , showFriend: true
  , audioContextRef
  , battleRoute: "/newb-level"
  }