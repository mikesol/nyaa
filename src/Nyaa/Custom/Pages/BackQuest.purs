module Nyaa.Custom.Pages.BackQuest where

import Prelude

import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Constants.Scores (backScore)
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.BattleRoute (BattleRoute(..))
import Nyaa.Types.Quest (Quest(..))
import Nyaa.Util.IntToString (intToString)
import Ocarina.WebAPI (AudioContext)

backQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
backQuest { audioContextRef } = questPage
  { name: "back-quest"
  , title: "Unlock Back!"
  , showFriend: true
  , scoreToWin: backScore
  , explainer:
      [ text_
          "Your prowess makes me smile. Perhaps I will reveal to you why I ask you to partake in these epic battles. Or not. Armed with "
      , D.span (klass_ "font-bold") [ text_ "Glide" ]
      , text_
          ", you are now invited to achieve "
      , D.span (klass_ "font-bold") [ text_ "Back" ]
      , text_ $ ", an infectiously cute effect, Nyā. To do so, you must garner " <> intToString backScore <> " points. Don't fail me."
      ]
  , quest: Back
  , audioContextRef
  , battleRoute: NewbLevel
  }