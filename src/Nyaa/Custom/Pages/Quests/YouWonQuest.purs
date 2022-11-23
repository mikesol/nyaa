module Nyaa.Custom.Pages.Quests.YouWonQuest where

import Prelude

import Data.Foldable (oneOf)
import Deku.Attribute ((!:=))
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
              "So that whole reward thing I was talking about. Your reward for finishing this whole game is..."
          ]
      , D.p_
          [ text_
              "The right to join the joyride.fm Discord! Ok, the cat (me) is out of the bag, this is just a quick game we made to test out some ideas. By getting to the end of it, you've proven that either our ideas were good or you're obsessed with cartoon cats. Either way, you should join our Discord community! To join, "
          , D.a (oneOf [ D.Href !:= "https://discord.gg/gUAPQAtbS8" ])
              [ text_ "click here" ]
          , text_ "!"
          ]
      ]
  , quest: Amplify
  , audioContextRef
  }