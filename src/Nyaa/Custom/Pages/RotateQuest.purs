module Nyaa.Custom.Pages.RotateQuest where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

rotateQuest :: Effect Unit
rotateQuest = questPage
  { name: "rotate-quest"
  , img: "bg-spacecat"
  , text: "Lorem ipsum"
  , next: pure unit
  }