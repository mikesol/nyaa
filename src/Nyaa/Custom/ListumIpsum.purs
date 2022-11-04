module Nyaa.Custom.ListumIpsum where

import Prelude

import Data.Foldable (oneOf)
import Deku.Attribute ((!:=))
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent)
import Nyaa.Ionic.Header (ionHeader)
import Nyaa.Ionic.Item (ionItem)
import Nyaa.Ionic.Label (ionLabel_)
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)

listumIpsum :: Effect Unit
listumIpsum = customComponent "listum-ipsum" { } \_ -> [
    ionHeader (oneOf [I.Translucent !:= true ]) [
        ionToolbar_ [
            ionTitle_ [text_ "Listum"]
        ]
    ],
    ionContent (oneOf [I.Fullscren !:= true]) [
      ionItem (oneOf [I.Button !:= true, D.Href !:= "/info-one"]) [ ionLabel_ [D.h3_ [text_ "Info One"]]],
      ionItem (oneOf [I.Button !:= true, D.Href !:= "/info-two"]) [ ionLabel_ [D.h3_ [text_ "Info Two"]]]
    ]
]