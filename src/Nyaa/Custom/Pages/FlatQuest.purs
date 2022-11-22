module Nyaa.Custom.Pages.FlatQuest where

import Prelude

import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.BattleRoute (BattleRoute(..))
import Ocarina.WebAPI (AudioContext)

flatQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
flatQuest { audioContextRef } = questPage
  { name: "flat-quest"
  , title: "Unlock Flat!"
  , showFriend: true
  , explainer:
      [ text_
          "Congratulations on following the tutorial. What a good follower you are. Nyā. You'll do well in this game. Score 14,000 points to unlock the "
      , D.span (klass_ "font-bold") [ text_ "Flat" ]
      , text_ " effect."
      ]
  , audioContextRef
  , battleRoute: NewbLevel
  }