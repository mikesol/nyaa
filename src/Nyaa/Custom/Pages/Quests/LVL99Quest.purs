module Nyaa.Custom.Pages.Quests.LVL99Quest where

import Prelude

import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Constants.Scores (track2Score)
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.Quest (Quest(..))
import Nyaa.Util.IntToString (intToString)
import Ocarina.WebAPI (AudioContext)

lvl99Quest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
lvl99Quest { audioContextRef } = questPage
  { name: "lvlnn-quest"
  , title: "Unlock LVL.99!"
  , scoreToWin: track2Score
  , showFriend: true
    , explainer:
      [ text_ "You've broken so many barriers and souls already. With "
      , D.span (klass_ "font-bold") [ text_ "Back" ]
      , text_ $
          ", you can finally reach a Nyā level of consciousness. Score " <> intToString track2Score <> " points to unlock the coveted "
      , D.span (klass_ "font-bold") [ text_ "Pro" ]
      , text_ " level."
      ]
  , quest: Lvl99
  , audioContextRef
  }