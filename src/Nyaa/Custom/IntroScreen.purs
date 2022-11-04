module Nyaa.Custom.IntroScreen where

import Prelude

import Data.Foldable (oneOf)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Button (simpleButton)
import Nyaa.Ionic.Col (ionCol_)
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent)
import Nyaa.Ionic.Grid (ionGrid)
import Nyaa.Ionic.Row (ionRow_)

introScreen :: Effect Unit
introScreen = customComponent "intro-screen" {} \_ ->
  --   [ ionContent (oneOf [ I.Fullscren !:= true, klass_ "background-cat" ])
  --       [ ionGrid (oneOf [ I.Fixed !:= true ])
  --           [ ionRow_ [ ionCol_ [], ionCol_ [ D.h1 (oneOf [ klass_ "" ]) [ text_ "Nyaa" ] ], ionCol_ [] ]
  --           , ionRow_ [ ionCol_ [], ionCol_ [ simpleButton { text: "Tutorial", click: pure unit } ], ionCol_ [] ]
  --           ]
  --       ]
  --   ]
  --[ ionContent (oneOf [ I.Fullscren !:= true, klass_ "background-cat flex flex-col justify-between h-100" ])
  [ D.div (oneOf [ klass_ "flex flex-col justify-between w-screen h-screen" ])
      [ D.div (oneOf [ klass_ "grow" ]) []
      , D.div (oneOf [ klass_ "flex flex-row" ])
          [ D.div (oneOf [ klass_ "grow" ]) []
          , D.div (oneOf [])
              [ D.div_ [ D.h1 (oneOf [ klass_ "text-center"]) [ text_ "Nyaa" ] ]
              , simpleButton { text: "Tutorial", click: pure unit }
              ]
          , D.div (oneOf [ klass_ "grow" ]) []
          ]
      , D.div (oneOf [ klass_ "grow" ]) []
      ]
  ]