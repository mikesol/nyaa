module Nyaa.App where

import Prelude

import Data.Array as A
import Data.Foldable (oneOf)
import Data.List (List(..), (:))
import Data.List as L
import Deku.Attribute ((!:=))
import Deku.Control (text_)
import Deku.Core (Domable)
import Deku.DOM as D
import Effect (Effect)
import Nyaa.Ionic.App (ionApp_)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent)
import Nyaa.Ionic.Header (ionHeader)
import Nyaa.Ionic.Item (ionItem)
import Nyaa.Ionic.Label (ionLabel_)
import Nyaa.Ionic.List (ionList_)
import Nyaa.Ionic.Nav (ionNav_)
import Nyaa.Ionic.Route (ionRoute)
import Nyaa.Ionic.Router (ionRouter_)
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)

-- Front page [Tutorial -> (Tutorial, Play)]
-- Tutorial quest
-- Tutorial
-- Lounge picker (after first quest is played)
-- Lounge 1 (requires sign in to unlock)
-- Game 1
-- Quest 1
-- Quest 2
-- Quest 3
-- Quest 4
-- Lounge 2
-- Game 2
-- Quest 5
-- Quest 6
-- Quest 7
-- Lounge 3
-- Game 3
-- Quest 8
-- Quest 9
-- End-of-game page (brag, continue)
-- Waiting to play (from quest)
-- Friends page (from quest)
-- Waiting to play with friend
-- Invited by friend
-- Invite accept & wait page
-- Invite reject page

app :: forall lock payload. Domable lock payload
app = ionApp_
  [ ionRouter_
      [ ionRoute (oneOf [ I.Url !:= "/", I.Component !:= "intro-screen" ]) []
      , ionRoute
          ( oneOf
              [ I.Url !:= "/tutorial-quest", I.Component !:= "tutorial-quest" ]
          )
          []
      ]
  , ionNav_ []
  ]

pages :: Array String
pages =
  [ "intro-screen"
  , "tutorial-quest"
  , "amplify-quest"
  , "camera-quest"
  , "dazzle-quest"
  , "equalize-quest"
  , "hide-quest"
  , "reverse-quest"
  , "rotate-quest"
  , "newb-lounge"
  , "pro-lounge"
  , "deity-lounge"
  , "newb-level"
  , "pro-level"
  , "deity-level"
  , "lounge-picker"
  ]

storybookCC :: Effect Unit
storybookCC = do
  customComponent "story-book" {} \_ -> do
    let
      go2 Nil = Nil
      go2 (head : tail) = do
        let
          shead = "/" <> head
        ( ionItem (oneOf [ I.Button !:= true, D.Href !:= shead ])
            [ ionLabel_ [ D.h3_ [ text_ head ] ] ]
        ) : go2 tail

      elts = go2 (L.fromFoldable pages)
    [ ionHeader (oneOf [ I.Translucent !:= true ])
        [ ionToolbar_
            [ ionTitle_ [ text_ "Storybook" ]
            ]
        ]
    , ionContent (oneOf [ I.Fullscren !:= true ]) [ionList_ (A.fromFoldable elts)]
    ]

storybook :: forall lock payload. Domable lock payload
storybook = ionApp_
  [ ionRouter_
      ( [ ionRoute (oneOf [ I.Url !:= "/", I.Component !:= "story-book" ])
            []
        ] <> A.fromFoldable routes

      )
  , ionNav_ []
  ]
  where

  go Nil = Nil
  go (head : tail) = do
    let
      shead = "/" <> head
    (ionRoute (oneOf [ I.Url !:= shead, I.Component !:= head ]) []) :
      go tail

  routes = go (L.fromFoldable pages)
