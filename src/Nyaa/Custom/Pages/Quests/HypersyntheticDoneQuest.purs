module Nyaa.Custom.Pages.Quests.HypersyntheticDoneQuest where

import Prelude

import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Constants.Scores (amplifyScore)
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

hypersyntheticDoneQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
hypersyntheticDoneQuest { audioContextRef } = questPage
  { name: "hypersyntheticdone-quest"
  , title: "Congrats!"
  , scoreToWin: amplifyScore
  , showFriend: true
  , explainer:
      [ D.p_
          [ text_ "You have bested HYPERSYNTHETIC. Visit the home page to play harder charts!"
          ]
      ]
  , quest: BeatHypersynthetic
  , audioContextRef
  }