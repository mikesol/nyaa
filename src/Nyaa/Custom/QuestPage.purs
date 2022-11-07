module Nyaa.Custom.QuestPage where

import Prelude

import Control.Plus (empty)
import Data.Foldable (oneOf)
import Deku.Attribute ((!:=), (:=))
import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Nyaa.Capacitor.Utils (Platform(..), getPlatformE)
import Nyaa.Components.UpperLeftBackButton (upperLeftBackButton)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.BackButton (ionBackButton)
import Nyaa.Ionic.Buttons (ionButtons)
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent)
import Nyaa.Ionic.Header (ionHeader)
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)

questPage
  :: { name :: String, img :: String, text :: String, next :: Effect Unit }
  -> Effect Unit
questPage i = customComponent i.name {} \_ ->
  -- [ ionHeader (oneOf [ I.Translucent !:= true ])
  --     [ ionToolbar_
  --         [ ionButtons (oneOf [ I.Slot !:= "start" ])
  --             [ ionBackButton (oneOf [ I.DefaultHref !:= "/" ]) []
  --             ]
  --         , ionTitle_ [ text_ "Info One" ]
  --         ]
  --     ]
  -- , ionContent (oneOf [ I.Fullscren !:= true ])
  --     [ D.div
  --         ( oneOf
  --             [ klass_
  --                 "bg-quest bg-no-repeat bg-cover bg-center w-full h-full grid grid-cols-3 grid-rows-3"
  --             ]
  --         )
  --         []
  --     ]
  -- ]
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