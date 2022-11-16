module Nyaa.Custom.Pages.PathTest where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.Array (groupBy)
import Data.Array.NonEmpty (NonEmptyArray, toArray)
import Data.Foldable (oneOf)
import Data.FunctorWithIndex (mapWithIndex)
import Data.Tuple (Tuple(..), snd)
import Data.Tuple.Nested ((/\))
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.Listeners (click_)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Nyaa.Capacitor.Utils (Platform(..))
import Nyaa.Constants.GameCenter as GCContants
import Nyaa.Constants.PlayGames as PGConstants
import Nyaa.GameCenter (ReportableAchievement(..))
import Nyaa.GameCenter as GC
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.BackButton (ionBackButton)
import Nyaa.Ionic.Button (ionButton)
import Nyaa.Ionic.Buttons (ionButtons)
import Nyaa.Ionic.Col (ionCol_)
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent)
import Nyaa.Ionic.Grid (ionGrid_)
import Nyaa.Ionic.Header (ionHeader)
import Nyaa.Ionic.Row (ionRow_)
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)
import Nyaa.PlayGames as PG

pathTest :: Effect Unit
pathTest = customComponent "path-test" { sessionId: "" } (pure unit) (pure unit)
  \{ sessionId } ->
    [ ionHeader (oneOf [ I.Translucent !:= true ])
        [ ionToolbar_
            [ ionButtons (oneOf [ I.Slot !:= "start" ])
                [ ionBackButton (oneOf [ I.DefaultHref !:= "/" ]) []
                ]
            , ionTitle_ [ text_ sessionId ]
            ]
        ]
    , ionContent (oneOf [ klass_ "ion-padding", I.Fullscren !:= true ])
        [ text_ $ "hello " <> sessionId
        ]

    ]
