module Nyaa.Custom.Builders.QuestPage where

import Prelude

import Data.Foldable (oneOf)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.BackButton (ionBackButton)
import Nyaa.Ionic.Button (ionButton)
import Nyaa.Ionic.Buttons (ionButtons)
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent)
import Nyaa.Ionic.Header (ionHeader)
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)

questPage
  :: { name :: String
     , title :: String
     , showFriend :: Boolean
     , battleRoute :: String
     }
  -> Effect Unit
questPage i = customComponent i.name {} (pure unit) (pure unit) \_ ->
  [ionHeader (oneOf [ I.Translucent !:= true ])
      [ ionToolbar_
          [ ionButtons (oneOf [ I.Slot !:= "start" ])
              [ ionBackButton (oneOf [ I.DefaultHref !:= "/" ]) []
              ]
          , ionTitle_ [ text_ i.title ]
          ]
      ], ionContent (oneOf [ I.Fullscren !:= true ])
      [ D.div
          ( oneOf
              [ klass_
                  "bg-beach bg-no-repeat bg-cover bg-center w-full h-full grid grid-cols-7 grid-rows-3"
              ]
          )
          [ 
           D.div (klass_ "row-start-2 col-start-2 row-span-1 col-span-3")
              ( [ ionButton (D.Href !:= i.battleRoute)
                    [ text_ "Start the battle"
                    ]
                ]
                -- for now we hide showing friends
                --   <> guard i.showFriend
                --     [ ionButton_ [ text_ "Battle a friend" ] ]
              )
          ]
      ]
  ]
