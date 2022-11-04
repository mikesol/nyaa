module Nyaa.Custom.InfoOne where

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
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)

infoOne :: Effect Unit
infoOne = customComponent "info-one" { } \_ -> [
    ionHeader (oneOf [I.Translucent !:= true ]) [
        ionToolbar_ [
            ionButtons (oneOf [I.Slot !:= "start" ]) [
                ionBackButton (oneOf [I.DefaultHref !:= "/" ]) []
            ],
            ionTitle_ [text_ "Info One"]
        ]
    ],
    ionContent (oneOf [klass_ "ion-padding", I.Fullscren !:= true]) [
      D.p_ [text_ "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque a pretium elit, in egestas odio. Etiam faucibus tincidunt eros, ut finibus augue varius at. Cras bibendum urna quis nunc elementum vehicula. Nulla facilisi. Proin non nisl rhoncus, blandit orci a, suscipit sapien. Ut dictum tempor elit a elementum. Maecenas sit amet suscipit erat. Donec mattis turpis sit amet lorem varius pellentesque. Donec quis magna purus. Donec tellus neque, ultrices et dui id, congue rutrum mauris. Donec nec turpis auctor, bibendum mauris quis, ultricies nunc. Etiam auctor tincidunt diam sit amet facilisis. Suspendisse placerat non metus sed elementum. Aliquam nec est in risus elementum pulvinar. Aenean vehicula urna nibh, interdum sollicitudin leo pellentesque sit amet."]
    ]
]