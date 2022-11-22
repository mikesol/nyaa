module Nyaa.Custom.Pages.DazzleQuest where

import Prelude

import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Constants.Scores (dazzleScore)
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.BattleRoute (BattleRoute(..))
import Nyaa.Types.Quest (Quest(..))
import Nyaa.Util.IntToString (intToString)
import Ocarina.WebAPI (AudioContext)

dazzleQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
dazzleQuest { audioContextRef } = questPage
  { name: "dazzle-quest"
  , title: "Unlock Dazzle!"
  , scoreToWin: dazzleScore
  , showFriend: true
  , explainer:
      [ text_ "The "
      , D.span (klass_ "font-bold") [ text_ "Hide" ]
      , text_ $
          " effect is a brutal, callus effect. Wield it with no pity and no remorse. In doing so, and in scoring " <> intToString dazzleScore <> " points, you shall earn the "
      , D.span (klass_ "font-bold") [ text_ "Dazzle" ]
      , text_ " effect. Nyā."
      ]
  , quest: Dazzle
  , audioContextRef
  , battleRoute: ProLevel
  }