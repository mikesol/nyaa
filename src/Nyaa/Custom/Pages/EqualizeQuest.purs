module Nyaa.Custom.Pages.EqualizeQuest where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

equalizeQuest :: Effect Unit
equalizeQuest = questPage
  { name: "equalize-quest"
  , img: "bg-spacecat"
  , text: "Lorem ipsum"
  , next: pure unit
  }