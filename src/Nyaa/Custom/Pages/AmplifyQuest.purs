module Nyaa.Custom.Pages.AmplifyQuest where

import Prelude

import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Constants.Scores (amplifyScore)
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.BattleRoute (BattleRoute(..))
import Nyaa.Types.Quest (Quest(..))
import Nyaa.Util.IntToString (intToString)
import Ocarina.WebAPI (AudioContext)

amplifyQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
amplifyQuest { audioContextRef } = questPage
  { name: "amplify-quest"
  , title: "Unlock Amplify!"
  , scoreToWin: amplifyScore
  , showFriend: true
    , explainer:
      [ text_
         $ "You've come to the end. After this point, I will have no choice but to reveal to you the reason I have put you through these trials and tribulations. But first, you must gain " <> intToString amplifyScore <> " points and sieze "
      , D.span (klass_ "font-bold") [ text_ "Amplify" ]
      , text_ ". It will be fierce, like me. You've been warned."
      ]
  , quest: Amplify
  , audioContextRef
  , battleRoute: DeityLevel
  }