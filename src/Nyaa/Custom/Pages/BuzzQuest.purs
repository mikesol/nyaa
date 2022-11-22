module Nyaa.Custom.Pages.BuzzQuest where

import Prelude

import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Constants.Scores (cameraScore)
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.BattleRoute (BattleRoute(..))
import Nyaa.Types.Quest (Quest(..))
import Nyaa.Util.IntToString (intToString)
import Ocarina.WebAPI (AudioContext)

buzzQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
buzzQuest { audioContextRef } = questPage
  { name: "buzz-quest"
  , title: "Unlock Buzz!"
  , scoreToWin: cameraScore
  , showFriend: true
  , explainer:
      [ text_
          "I am not unpleased. Nyā. Now that you can wield "
      , D.span (klass_ "font-bold") [ text_ "Flat" ]
      , text_ $
          ", I expect you to use it with reckless abandon. Score " <> intToString cameraScore <> " points to unlock the next effect that I affectionately (nyā) call"
      , D.span (klass_ "font-bold") [ text_ "Buzz" ]
      , text_ "."
      ]
  , quest: Camera
  , audioContextRef
  , battleRoute: NewbLevel
  }