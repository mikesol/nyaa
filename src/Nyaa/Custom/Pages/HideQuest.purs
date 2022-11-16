module Nyaa.Custom.Pages.HideQuest where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

hideQuest :: Effect Unit
hideQuest = questPage
  { name: "hide-quest"
  , title: "Unlock Hide!"
  , showFriend: true
  , battleRoute: "/pro-level"
  }