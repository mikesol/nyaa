module Nyaa.App where

import Prelude

import Data.Filterable (filter)
import Data.Foldable (oneOf)
import Deku.Attribute ((!:=))
import Deku.Control (text_)
import Deku.Core (Domable)
import Deku.DOM as D
import Effect (Effect)
import Effect.Ref as Ref
import Nyaa.Ionic.App (ionApp_)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent_)
import Nyaa.Ionic.Header (ionHeader)
import Nyaa.Ionic.Item (ionItem)
import Nyaa.Ionic.Label (ionLabel_)
import Nyaa.Ionic.List (ionList_)
import Nyaa.Ionic.Nav (ionNav_)
import Nyaa.Ionic.Route (ionRoute)
import Nyaa.Ionic.Router (ionRouter_)
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)
import Ocarina.WebAPI (AudioContext)

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

basicPages :: Array String
basicPages =
  [ "story-book"
  , "intro-screen"
  , "dev-admin"
  , "flat-quest"
  , "buzz-quest"
  , "glide-quest"
  , "back-quest"
  , "showmehow-quest"
  , "rotate-quest"
  , "hide-quest"
  , "dazzle-quest"
  , "lvlnn-quest"
  , "crush-quest"
  , "amplify-quest"
  , "newb-lounge"
  , "pro-lounge"
  , "deity-lounge"
  , "lounge-picker"
  , "profile-page"
  ]

levelPages :: Array String
levelPages =
  [ "equalize-level"
  , "camera-level"
  , "glide-level"
  , "back-level"
  , "lvlnn-level"
  , "rotate-level"
  , "hide-level"
  , "dazzle-level"
  , "showmehow-level"
  , "crush-level"
  , "amplify-level"
  ]

storybookCC :: Effect Unit
storybookCC = do
  customComponent_ "story-book" {} \_ -> do
    let
      basicEntries :: forall lock payload. Array (Domable lock payload)
      basicEntries = basicPages <#> \page ->
        ionItem (oneOf [ I.Button !:= true, D.Href !:= "/" <> page ])
          [ ionLabel_ [ D.h3_ [ text_ page ] ]
          ]

      levelEntries :: forall lock payload. Array (Domable lock payload)
      levelEntries = levelPages <#> \page ->
        ionItem
          (oneOf [ I.Button !:= true, D.Href !:= "/" <> page <> "/debug-room" ])
          [ ionLabel_ [ D.h3_ [ text_ page ] ]
          ]
    [ ionHeader (oneOf [ I.Translucent !:= true ])
        [ ionToolbar_
            [ ionTitle_ [ text_ "Storybook" ]
            ]
        ]
    , ionContent (oneOf [ I.Fullscren !:= true ])
        [ ionList_ $ basicEntries <> levelEntries ]
    ]

makeApp
  :: forall lock payload
   . Boolean
  -> String
  -> (Ref.Ref AudioContext)
  -> Domable lock payload
makeApp withAdmin homeIs _ = ionApp_
  [ ionRouter_
      ( [ ionRoute (oneOf [ I.Url !:= "/", I.Component !:= homeIs ])
            []
        ] <> basicIonRoutes <> levelIonRoutes

      )
  , ionNav_ []
  ]
  where
  basicIonRoutes :: Array (Domable lock payload)
  basicIonRoutes = basicRoutes <#> \page ->
    ionRoute (oneOf [ I.Url !:= "/" <> page, I.Component !:= page ]) []

  levelIonRoutes :: Array (Domable lock payload)
  levelIonRoutes = levelPages <#> \page ->
    ionRoute
      ( oneOf
          [ I.Url !:= "/" <> page <> "/:roomId/:isHost", I.Component !:= page ]
      )
      []

  basicRoutes :: Array String
  basicRoutes = (if withAdmin then identity else filter (_ /= "dev-admin"))
    basicPages

storybook :: forall lock payload. (Ref.Ref AudioContext) -> Domable lock payload
storybook = makeApp true "story-book"

app :: forall lock payload. (Ref.Ref AudioContext) -> Domable lock payload
app = makeApp false "intro-screen"
