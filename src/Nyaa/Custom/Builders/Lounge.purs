module Nyaa.Custom.Builders.Lounge where

import Prelude

import Data.Foldable (oneOf)
import Data.Maybe (Maybe(..))
import Data.Monoid (guard)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (switcher, text_)
import Deku.Core (Domable, Nut)
import Deku.DOM as D
import Effect (Effect)
import FRP.Event (Event)
import Nyaa.Firebase.Firebase (Profile(..), Profile')
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.BackButton (ionBackButton)
import Nyaa.Ionic.Buttons (ionButtons)
import Nyaa.Ionic.Card (ionCard)
import Nyaa.Ionic.CardContent (ionCardContent_)
import Nyaa.Ionic.CardHeader (ionCardHeader_)
import Nyaa.Ionic.CardSubtitle (ionCardSubtitle_)
import Nyaa.Ionic.CardTitle (ionCardTitle_)
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent_)
import Nyaa.Ionic.Header (ionHeader)
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)
import Nyaa.Some (Some)

newtype Mission = Mission
  { title :: String
  , index :: Int
  , description :: Nut
  , img :: String
  , path :: String
  , unlocker :: Some Profile' -> Maybe Boolean
  }

achievement
  :: forall lock payload
   . Profile
  -> Mission
  -> Domable lock payload
achievement (Profile profile) (Mission opts) = do
  let profileNotUnlocked = opts.unlocker profile /= Just true
  ionCard
    ( oneOf
        ( [ D.Disabled !:= profileNotUnlocked ] <> guard
            (not profileNotUnlocked)
            [ D.Href !:= opts.path ]
        )
    )
    [ D.div (klass_ "flex")
        [ D.div (klass_ "grow") []
        , D.img
            ( oneOf
                [ klass_ "w-28"
                , D.Alt !:=
                    ("Image representing the " <> opts.title <> " achievement.")
                , D.Src !:= opts.img
                ]
            )
            []
        , D.div (klass_ "grow") []
        ]
    , ionCardHeader_
        [ ionCardTitle_ [ text_ opts.title ]
        , ionCardSubtitle_ [ text_ ("Mission " <> show opts.index) ]
        ]
    , ionCardContent_
        [ opts.description
        ]
    ]

lounge
  :: { name :: String
     , title :: String
     , profileState :: Event { profile :: Profile }
     , missions :: Array Mission
     }
  -> Effect Unit
lounge i = customComponent_ i.name {} \_ ->
  [ ionHeader (oneOf [ I.Translucent !:= true ])
      [ ionToolbar_
          [ ionButtons (oneOf [ I.Slot !:= "start" ])
              [ ionBackButton (oneOf [ I.DefaultHref !:= "/" ]) []
              ]
          , ionTitle_ [ text_ i.title ]
          ]
      ]
  , ionContent (oneOf [ I.Fullscren !:= true ])
      [ flip switcher i.profileState \{ profile } -> D.div
          (oneOf [ klass_ "grid grid-cols-3 gap-4 w-full" ])
          (i.missions <#> achievement profile)
      ]
  ]
