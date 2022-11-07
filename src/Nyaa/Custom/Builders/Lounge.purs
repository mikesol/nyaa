module Nyaa.Custom.Builders.Lounge where

import Prelude

import Data.Foldable (oneOf)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Deku.Listeners (click_)
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

lounge
  :: { name :: String
     , title :: String
     , img :: String
     , text :: String
     , next :: Effect Unit
     }
  -> Effect Unit
lounge i = customComponent i.name {} \_ ->
  [ ionHeader (oneOf [ I.Translucent !:= true ])
      [ ionToolbar_
          [ ionButtons (oneOf [ I.Slot !:= "start" ])
              [ ionBackButton (oneOf []) []
              , ionTitle_ [ text_ i.title ]
              ]
          ]
      ]
  , ionContent (oneOf [ I.Fullscren !:= true ])
      [ D.div (oneOf [ klass_ "w-full h-full grid grid-cols-3 grid-rows-3" ])
          [ D.div
              ( oneOf
                  [ klass_ $ "row-start-1 row-span-3 col-start-1 col-span-1"
                  ]
              )
              [ ionButton (oneOf [ click_ i.next ]) [ text_ "Play now" ] ]
          , D.div
              (oneOf [ klass_ "row-start-1 row-span-2 col-start-2 col-span-2" ])
              [ text_ i.text ]
          , D.div
              (oneOf [ klass_ "row-start-3 row-span-1 col-start-3 col-span-1" ])
              [ ionButton (oneOf [ click_ i.next ]) [ text_ "Continue" ] ]
          ]
      ]
  ]