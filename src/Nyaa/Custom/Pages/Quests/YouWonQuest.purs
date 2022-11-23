module Nyaa.Custom.Pages.Quests.YouWonQuest where

import Prelude

import Data.Foldable (oneOf)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Constants.Scores (amplifyScore)
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.Quest (Quest(..))
import Ocarina.WebAPI (AudioContext)

youwonQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
youwonQuest { audioContextRef } = questPage
  { name: "youwon-quest"
  , title: "You Won!"
  , scoreToWin: amplifyScore -- keep this the same
  , showFriend: true
  , explainer:
      [ D.p_
          [ text_
              "So that whole reward thing I was talking about. Your reward for finishing this game is...the right to join our "
          , D.a (klass_ "font-bold") [ text_ "Discord" ]
          , text_
              "! Tbh, this is just a quick game we made to test out some ideas. By getting to the end of it, you've proven that either we're on the right track or you're obsessed with cats. Either way, you should "
          , D.a (oneOf [ D.Href !:= "https://discord.gg/gUAPQAtbS8" ])
              [ text_ "click here" ]
          , text_ " to join our community!"
          ]
      ]
  , quest: Amplify
  , audioContextRef
  }