module Nyaa.Custom.Pages.TutorialQuest where

import Prelude

import Deku.Control (text_)
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.BattleRoute (BattleRoute(..))
import Ocarina.WebAPI (AudioContext)

tutorialQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
tutorialQuest { audioContextRef } = questPage
  { name: "tutorial-quest"
  , title: "Tutorial"
  , explainer:
      [ text_
          "Oh hello! Hehe! Welcome to my tutorial. In it, I will teach you to engage in a death battle with your opponent, wreaking havoc on their game in your maniacal pursuit of glory. Let's begin!"
      ]
  , showFriend: false
  , audioContextRef
  , battleRoute: TutorialLevel
  }