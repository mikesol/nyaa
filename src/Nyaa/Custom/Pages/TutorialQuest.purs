module Nyaa.Custom.Pages.TutorialQuest where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

tutorialQuest :: Effect Unit
tutorialQuest = questPage
  { name: "tutorial-quest"
  , title: "Tutorial"
  , showFriend: false
  , battleRoute: "/tutorial-level"
  }