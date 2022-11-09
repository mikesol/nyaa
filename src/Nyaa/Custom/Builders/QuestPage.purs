module Nyaa.Custom.Builders.QuestPage where

import Prelude

import Data.Foldable (oneOf)
import Data.Monoid (guard)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Nyaa.Components.UpperLeftBackButton (upperLeftBackButton)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Button (ionButton_)
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent)

questPage
  :: { name :: String
     , showFriend :: Boolean
     }
  -> Effect Unit
questPage i = customComponent i.name {} \_ ->
  [ ionContent (oneOf [ I.Fullscren !:= true ])
      [ D.div
          ( oneOf
              [ klass_
                  "bg-quest bg-no-repeat bg-cover bg-center w-full h-full grid grid-cols-3 grid-rows-3"
              ]
          )
          [ upperLeftBackButton
          , D.div (klass_ "row-start-2 col-start-1 row-span-1 col-span-1")
              ( [ ionButton_ [ text_ "Start the battle" ] ]
                  <> guard i.showFriend
                    [ ionButton_ [ text_ "Battle a friend" ] ]
              )
          ]
      ]
  ]