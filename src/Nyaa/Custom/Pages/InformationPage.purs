module Nyaa.Custom.Pages.InformationPage where

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
import Nyaa.Ionic.Content (ionContent_)
import Nyaa.Ionic.Custom (customComponent_)
import Nyaa.Ionic.Header (ionHeader)
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)

informationTextFirst :: String
informationTextFirst =
  """
Hi, you found the information page! We're joyride.fm, an indie
game development team with roots from Japan 🇯🇵, Finland 🇫🇮,
and the Philippines 🇵🇭.
"""

informationTextSecond :: String
informationTextSecond =
  """
We're on a mission to build multi-player rhythm games. While
we're keeping standard mechanics like notes and judgment lines,
we aim to introduce novel gameplay mechanics, narrative elements,
and aesthetics to expand the genre further. We hope to be able to
build unique and meaningful social experiences through our games.
"""

informationTextThird :: String
informationTextThird =
  """
Feel free to join our 
"""

informationPage :: Effect Unit
informationPage = customComponent_ "information-page" {} \_ ->
  [ ionHeader (oneOf [ I.Translucent !:= true ])
      [ ionToolbar_
          [ ionButtons (oneOf [ I.Slot !:= "start" ])
              [ ionBackButton (oneOf [ I.DefaultHref !:= "/" ]) []
              ]
          , ionTitle_ [ text_ "Information" ]
          ]
      ]
  , ionContent_
      [ D.main (oneOf [ klass_ "text-xl p-8" ])
          [ D.article_
              [ text_ informationTextFirst
              , D.br_ []
              , D.br_ []
              , text_ informationTextSecond
              , D.br_ []
              , D.br_ []
              , text_ "Feel free to join our "
              , D.a
                  ( oneOf
                      [ D.Href !:= "https://https://discord.gg/gUAPQAtbS8"
                      , D.Target !:= "_blank"
                      ]
                  )
                  [ text_ "Discord"
                  ]
              , text_ "! We build games in the open!"
              ]
          ]
      ]
  ]