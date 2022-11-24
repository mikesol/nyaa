module Nyaa.Custom.Pages.Quests.Lvl99DoneQuest where

import Prelude

import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Constants.Scores (amplifyScore)
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

lvl99DoneQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
lvl99DoneQuest { audioContextRef } = questPage
  { name: "lvlnndone-quest"
  , title: "Congrats!"
  , scoreToWin: amplifyScore
  , showFriend: true
  , explainer:
      [ D.p_
          [ text_ "You have earned all there is to learn at the Pro Level. Visit the home page to play harder charts!"
          ]
      ]
  , quest: BeatLvl99
  , audioContextRef
  }