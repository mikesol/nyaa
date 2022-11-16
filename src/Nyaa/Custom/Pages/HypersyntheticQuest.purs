module Nyaa.Custom.Pages.HypersyntheticQuest where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

hypersyntheticQuest :: Effect Unit
hypersyntheticQuest = questPage
  { name: "hypersynthetic-quest"
  , title: "Unlock HYPERSYNTHETIC!"
  , showFriend: true
  , battleRoute: "/newb-level"
  }