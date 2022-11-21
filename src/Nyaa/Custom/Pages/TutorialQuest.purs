module Nyaa.Custom.Pages.TutorialQuest where

import Prelude

import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Custom.Builders.QuestPage (tutorialQuestPage)
import Nyaa.Types.BattleRoute (BattleRoute(..))
import Ocarina.WebAPI (AudioContext)

tutorialQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
tutorialQuest { audioContextRef } = tutorialQuestPage
  { name: "tutorial-quest"
  , title: "Tutorial"
  , showFriend: false
  , audioContextRef
  , battleRoute: TutorialLevel
  }