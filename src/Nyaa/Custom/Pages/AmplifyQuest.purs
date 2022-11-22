module Nyaa.Custom.Pages.AmplifyQuest where

import Prelude

import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.BattleRoute (BattleRoute(..))
import Ocarina.WebAPI (AudioContext)

amplifyQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
amplifyQuest { audioContextRef } = questPage
  { name: "amplify-quest"
  , title: "Unlock Amplify!"
  , showFriend: true
    , explainer:
      [ text_
          "You've come to the end. After this point, I will have no choice but to reveal to you the reason I have put you through these trials and tribulations. But first, you must gain 60,000 points and sieze "
      , D.span (klass_ "font-bold") [ text_ "Amplify" ]
      , text_ ". It will be fierce, like me. You've been warned."
      ]
  , audioContextRef
  , battleRoute: DeityLevel
  }