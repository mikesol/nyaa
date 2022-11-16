module Nyaa.Custom.Pages.LoungePicker where

import Prelude

import Data.Foldable (oneOf)
import Data.Maybe (Maybe(..))
import Data.Monoid (guard)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (switcher, text_)
import Deku.Core (Domable)
import Deku.DOM as D
import Effect (Effect)
import FRP.Event (Event)
import Nyaa.Assets (catURL)
import Nyaa.Firebase.Firebase (Profile(..), Profile')
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.BackButton (ionBackButton)
import Nyaa.Ionic.Buttons (ionButtons)
import Nyaa.Ionic.Card (ionCard)
import Nyaa.Ionic.CardHeader (ionCardHeader_)
import Nyaa.Ionic.CardSubtitle (ionCardSubtitle_)
import Nyaa.Ionic.CardTitle (ionCardTitle_)
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent)
import Nyaa.Ionic.Header (ionHeader)
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)
import Nyaa.Some (Some)
import Nyaa.Some (get)
import Type.Proxy (Proxy(..))

newtype Lounge = Lounge
  { title :: String
  , index :: Int
  , img :: String
  , path :: String
  , unlocker :: Some Profile' -> Maybe Boolean
  }

lounge
  :: forall lock payload
   . Profile
  -> Lounge
  -> Domable lock payload
lounge (Profile profile) (Lounge opts) = do
  let profileNotUnlocked = opts.unlocker profile /= Just true
  ionCard
    ( oneOf
        ( [ D.Disabled !:= profileNotUnlocked, klass_ "grow" ] <> guard
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
    -- , ionCardContent_
    --     [ opts.description
    --     ]
    ]

lounges :: Array Lounge
lounges =
  [ Lounge
      { title: "HYPERSYNTHETIC"
      , index: 1
      , img: catURL
      , path: "/nweb-lounge"
      , unlocker: get
          ( Proxy
              :: Proxy
                   "hasCompletedTutorial"
          )
      }
  , Lounge
      { title: "Show Me How"
      , index: 1
      , img: catURL
      , path: "/nweb-lounge"
      , unlocker: get
          ( Proxy
              :: Proxy
                   "back"
          )
      }
  , Lounge
      { title: "LVL.99"
      , index: 1
      , img: catURL
      , path: "/nweb-lounge"
      , unlocker: \p -> (&&)
          <$> get
            ( Proxy
                :: Proxy
                     "dazzle"
            )
            p
          <*> get
            ( Proxy
                :: Proxy
                     "hasPaid"
            )
            p
      }
  ]

loungePicker
  :: { profileState :: Event { profile :: Profile }
     }
  -> Effect Unit
loungePicker i = customComponent "lounge-picker" {} (pure unit) (pure unit)
  \_ ->
    [ ionHeader (oneOf [ I.Translucent !:= true ])
        [ ionToolbar_
            [ ionButtons (oneOf [ I.Slot !:= "start" ])
                [ ionBackButton (oneOf [ I.DefaultHref !:= "/" ]) []
                ]
            , ionTitle_ [ text_ "Pick a Track" ]
            ]
        ]
    , ionContent (oneOf [ I.Fullscren !:= true ])
        [ flip switcher i.profileState \{ profile } -> D.div
            (oneOf [ klass_ "flex-col flex w-full h-full" ])
            [ D.div (klass_ "grow") []
            , D.div (klass_ "flex flex-row") (lounges <#> lounge profile)
            , D.div (klass_ "grow") []
            ]
        ]
    ]
