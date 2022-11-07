module Nyaa.Components.UpperLeftBackButton where

import Data.Foldable (oneOf)
import Deku.Attribute ((!:=))
import Deku.Core (Nut)
import Deku.DOM as D
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.BackButton (ionBackButton)
import Nyaa.Ionic.Buttons (ionButtons)

upperLeftBackButton :: Nut
upperLeftBackButton = D.div
  ( oneOf
      [ D.Class !:=
          "col-start-1 col-span-1 row-start-1 row-span-1 place-self-start pt-2 pl-1"
      ]
  )
  [ ionButtons (oneOf [])
      [ ionBackButton (oneOf [ I.DefaultHref !:= "/" ]) []
      ]
  ]