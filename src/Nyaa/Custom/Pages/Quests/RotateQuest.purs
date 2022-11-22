module Nyaa.Custom.Pages.Quests.RotateQuest where

import Prelude

import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Constants.Scores (rotateScore)
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.Quest (Quest(..))
import Nyaa.Util.IntToString (intToString)
import Ocarina.WebAPI (AudioContext)

rotateQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
rotateQuest { audioContextRef } = questPage
  { name: "rotate-quest"
  , title: "Unlock Rotate!"
  , scoreToWin: rotateScore
  , explainer:
      [ text_ $
          "You did it, you leveled up. I knew you could do it ❤️. If you score more than " <> intToString rotateScore <> " points on this mega-hard chart, you'll unlock the "
      , D.span (klass_ "font-bold") [ text_ "Rotate" ]
      , text_ " effect. Good luck!"
      ]
  , quest: Rotate
  , showFriend: true
  , audioContextRef
  }