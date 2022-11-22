module Nyaa.Custom.Pages.GlideQuest where

import Prelude

import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.BattleRoute (BattleRoute(..))
import Ocarina.WebAPI (AudioContext)

glideQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
glideQuest { audioContextRef } = questPage
  { name: "glide-quest"
  , title: "Unlock Glide!"
  , explainer:
      [ text_
          "Your cuteness rivals only mine. Nyā. Use "
      , D.span (klass_ "font-bold") [ text_ "Buzz" ]
      , text_
          " to disorient your enemy, but watch out for they will use the same against you. If you can score 25,000 points, unto you shall be bestowed "
      , D.span (klass_ "font-bold") [ text_ "Glide" ]
      , text_ "."
      ]
  , showFriend: true
  , audioContextRef
  , battleRoute: NewbLevel
  }