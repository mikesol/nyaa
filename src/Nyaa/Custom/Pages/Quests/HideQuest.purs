module Nyaa.Custom.Pages.Quests.HideQuest where

import Prelude

import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Constants.Scores (hideScore)
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.Quest (Quest(..))
import Nyaa.Util.IntToString (intToString)
import Ocarina.WebAPI (AudioContext)

hideQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
hideQuest { audioContextRef } = questPage
  { name: "hide-quest"
  , title: "Unlock Hide!"
  , scoreToWin: hideScore
  , explainer:
      [ text_ "Armed with the "
      , D.span (klass_ "font-bold") [ text_ "Rotate" ]
      , text_ $
          " effect, my expectation is that you will mercilessly pummel your opponent with it. If you score more than " <> intToString hideScore <> " points, I'll reward you with the "
      , D.span (klass_ "font-bold") [ text_ "Hide" ]
      , text_ " effect. Go get 'em, champ!"
      ]
  , quest: Hide
  , showFriend: true
  , audioContextRef
  }