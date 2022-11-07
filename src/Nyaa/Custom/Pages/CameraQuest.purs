module Nyaa.Custom.Pages.CameraQuest where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

cameraQuest :: Effect Unit
cameraQuest = questPage
  { name: "camera-quest"
  , img: "bg-spacecat"
  , text: "Lorem ipsum"
  , next: pure unit
  }