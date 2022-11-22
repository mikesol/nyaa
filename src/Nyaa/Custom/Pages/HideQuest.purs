module Nyaa.Custom.Pages.HideQuest where

import Prelude

import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.BattleRoute (BattleRoute(..))
import Ocarina.WebAPI (AudioContext)

hideQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
hideQuest { audioContextRef } = questPage
  { name: "hide-quest"
  , title: "Unlock Hide!"
  , explainer:
      [ text_ "Armed with the "
      , D.span (klass_ "font-bold") [ text_ "Rotate" ]
      , text_
          " effect, my expectation is that you will mercilessly pummel your opponent with it. If you score more than 30,000 points, I'll reward you with the "
      , D.span (klass_ "font-bold") [ text_ "Hide" ]
      , text_ " effect. Go get 'em, champ!"
      ]
  , showFriend: true
  , audioContextRef
  , battleRoute: ProLevel
  }