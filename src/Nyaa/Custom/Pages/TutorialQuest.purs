module Nyaa.Custom.Pages.TutorialQuest where

import Prelude

import Deku.Control (text_)
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.BattleRoute (BattleRoute(..))
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

tutorialQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
tutorialQuest { audioContextRef } = questPage
  { name: "tutorial-quest"
  , title: "Tutorial"
  , scoreToWin: -42 -- ugh, we should get rid of the tutorial as a quest, it doesn't make sense and results in lots of values in this record being nonsensical
  , quest: Hypersynthetic
  , explainer:
      [ text_ $
          "Oh hello! Hehe! Welcome to my tutorial. In it, I will teach you to engage in a death battle with your opponent, wreaking havoc on their game in your maniacal pursuit of glory. Let's begin!"
      ]
  , showFriend: false
  , audioContextRef
  , battleRoute: TutorialLevel
  }