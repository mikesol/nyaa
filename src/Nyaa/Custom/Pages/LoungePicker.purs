module Nyaa.Custom.Pages.LoungePicker where

import Prelude

import Data.Foldable (oneOf)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Nyaa.Components.UpperLeftBackButton (upperLeftBackButton)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent)
import Nyaa.Ionic.Item (ionItem_)
import Nyaa.Ionic.List (ionList_)
import Nyaa.Ionic.RouterLink (ionRouterLink)

loungePicker :: Effect Unit
loungePicker = customComponent "lounge-picker" {} \_ ->
  [ ionContent (oneOf [ I.Fullscren !:= true ])
      [ D.div
          ( oneOf
              [ klass_
                  "w-full h-full grid grid-cols-3 grid-rows-3"
              ]
          )
          [ upperLeftBackButton
          , D.div
              ( oneOf
                  [ klass_
                      "col-start-1 row-start-1 col-span-3 row-span-3"
                  ]
              )
              [ ionList_
                  [ ionItem_
                      [ ionRouterLink (D.Href !:= "/newb-level")
                          [ text_ "Lounge 1" ]
                      ]
                  , ionItem_
                      [ ionRouterLink (D.Href !:= "/pro-level")
                          [ text_ "Lounge 2" ]
                      ]
                  , ionItem_
                      [ ionRouterLink (D.Href !:= "/deity-level")
                          [ text_ "Lounge 3" ]
                      ]

                  ]
              ]
          ]
      ]
  ]