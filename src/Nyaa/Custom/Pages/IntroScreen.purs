module Nyaa.Custom.Pages.IntroScreen where

import Prelude

import Data.Foldable (oneOf)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Nyaa.Ionic.Button (ionButton)
import Nyaa.Ionic.Content (ionContent_)
import Nyaa.Ionic.Custom (customComponent)

introScreen :: Effect Unit
introScreen = customComponent "intro-screen" {} \_ ->

  [ ionContent_
      [ D.div (oneOf [ klass_ "flex flex-col justify-between w-full h-full" ])
          [ D.div (oneOf [ klass_ "grow" ]) []
          , D.div (oneOf [ klass_ "flex flex-row" ])
              [ D.div (oneOf [ klass_ "grow" ]) []
              , D.div (oneOf [])
                  [ D.div_ [ D.h1 (oneOf [ klass_ "text-center" ]) [ text_ "Nyaa" ] ]
                  , ionButton (oneOf [ D.Href !:= "/tutorial-quest" ]) [ text_ "Tutorial" ]
                  ]
              , D.div (oneOf [ klass_ "grow" ]) []
              ]
          , D.div (oneOf [ klass_ "grow" ]) []
          ]
      ]
  ]