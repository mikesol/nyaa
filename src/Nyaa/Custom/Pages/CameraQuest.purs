module Nyaa.Custom.Pages.CameraQuest where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

cameraQuest :: Effect Unit
cameraQuest = questPage
  { name: "camera-quest"
  , showFriend: true
  , battleRoute: "/newb-level"
  }