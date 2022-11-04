module Nyaa.Custom.QuestPage where

import Prelude

import Data.Foldable (oneOf)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.BackButton (ionBackButton)
import Nyaa.Ionic.Buttons (ionButtons)
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent)
import Nyaa.Ionic.Header (ionHeader)
import Nyaa.Ionic.Toolbar (ionToolbar_)

questPage :: { name :: String } -> Effect Unit
questPage { name } = customComponent name {} \_ ->
  [ ionHeader (oneOf [ I.Translucent !:= true ])
      [ ionToolbar_
          [ ionButtons (oneOf [ I.Slot !:= "start" ])
              [ ionBackButton (oneOf []) []
              ]
          ]
      ]
  , ionContent (oneOf [ I.Fullscren !:= true ])
      [ D.div (oneOf [ klass_ "w-full h-full grid grid-cols-3 grid-rows-3" ])
          [ D.div (oneOf [ klass_ "row-start-1 row-span-1 col-start-1 col-span-1" ]) [ text_ "a" ]
          , D.div (oneOf [ klass_ "row-start-3 row-span-3 col-start-1 col-span-1" ]) [ text_ "z" ]
          ]
      ]
  ]