module Nyaa.Custom.Pages.TutorialQuest where

import Effect.Ref as Ref
import Ocarina.WebAPI (AudioContext)

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (tutorialQuestPage)

tutorialQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
tutorialQuest { audioContextRef } = tutorialQuestPage
  { name: "tutorial-quest"
  , title: "Tutorial"
  , showFriend: false
  , audioContextRef
  , battleRoute: "/tutorial-level"
  }