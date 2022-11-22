module Nyaa.Custom.Pages.GlideQuest where

import Prelude

import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Constants.Scores (glideScore)
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.BattleRoute (BattleRoute(..))
import Nyaa.Types.Quest (Quest(..))
import Nyaa.Util.IntToString (intToString)
import Ocarina.WebAPI (AudioContext)

glideQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
glideQuest { audioContextRef } = questPage
  { name: "glide-quest"
  , title: "Unlock Glide!"
  , scoreToWin: glideScore
  , explainer:
      [ text_
          "Your cuteness rivals only mine. Nyā. Use "
      , D.span (klass_ "font-bold") [ text_ "Buzz" ]
      , text_ $
          " to disorient your enemy, but watch out for they will use the same against you. If you can score " <> intToString glideScore <> " points, unto you shall be bestowed "
      , D.span (klass_ "font-bold") [ text_ "Glide" ]
      , text_ "."
      ]
  , quest: Glide
  , showFriend: true
  , audioContextRef
  , battleRoute: NewbLevel
  }