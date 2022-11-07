module Nyaa.Custom.Pages.HideQuest where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

hideQuest :: Effect Unit
hideQuest = questPage
  { name: "hide-quest"
  , img: "bg-spacecat"
  , text: "Lorem ipsum"
  , next: pure unit
  }