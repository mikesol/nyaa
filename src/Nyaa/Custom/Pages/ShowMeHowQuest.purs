module Nyaa.Custom.Pages.ShowMeHowQuest where

import Prelude

import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Constants.Scores (track3Score)
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.BattleRoute (BattleRoute(..))
import Nyaa.Types.Quest (Quest(..))
import Nyaa.Util.IntToString (intToString)
import Ocarina.WebAPI (AudioContext)

showMeHowQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
showMeHowQuest { audioContextRef } = questPage
  { name: "showmehow-quest"
  , title: "Show Me How"
  , scoreToWin: track3Score
  , explainer:
      [ text_
          "Nyā! You are on the cusp of greatness. Having unlocked "
      , D.span (klass_ "font-bold") [ text_ "Dazzle" ]
      , text_ $
          " you are now ready to kick it into high gear. Score " <> intToString track3Score <> " points to access the "
      , D.span (klass_ "font-bold") [ text_ "Deity Level" ]
      , text_ "."
      ]
  , quest: ShowMeHow
  , showFriend: true
  , audioContextRef
  , battleRoute: ProLevel
  }