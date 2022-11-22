module Nyaa.Custom.Pages.LVL99Quest where

import Prelude

import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.BattleRoute (BattleRoute(..))
import Ocarina.WebAPI (AudioContext)

lvl99Quest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
lvl99Quest { audioContextRef } = questPage
  { name: "lvlnn-quest"
  , title: "Unlock Show Me How!"
  , showFriend: true
    , explainer:
      [ text_ "You've broken so many barriers and souls already. With "
      , D.span (klass_ "font-bold") [ text_ "Dazzle" ]
      , text_
          ", you can finally reach a Nyā level of consciousness. Score 50,000 points to unlock "
      , D.span (klass_ "font-bold") [ text_ "Deity" ]
      , text_ " level."
      ]
  , audioContextRef
  , battleRoute: DeityLevel
  }