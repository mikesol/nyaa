module Nyaa.Custom.Builders.QuestPage where

import Prelude

import Data.Foldable (oneOf)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.DOM as D
import Effect (Effect)
import Nyaa.Components.UpperLeftBackButton (upperLeftBackButton)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent)

questPage
  :: { name :: String, img :: String, text :: String, next :: Effect Unit }
  -> Effect Unit
questPage i = customComponent i.name {} \_ ->
  [ ionContent (oneOf [ I.Fullscren !:= true ])
      [ D.div
          ( oneOf
              [ klass_
                  "bg-quest bg-no-repeat bg-cover bg-center w-full h-full grid grid-cols-3 grid-rows-3"
              ]
          )
          [ upperLeftBackButton ]
      ]
  ]