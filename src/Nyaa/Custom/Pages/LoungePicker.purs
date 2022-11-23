module Nyaa.Custom.Pages.LoungePicker where

import Prelude

import Data.Foldable (oneOf)
import Data.List (List(..), (:))
import Data.Maybe (Maybe(..))
import Data.Monoid (guard)
import Data.Tuple.Nested ((/\), type (/\))
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
import Nyaa.Ionic.Custom (customComponent_)
import Nyaa.Ionic.Header (ionHeader)
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)
import Nyaa.Some (Some, get)
import Type.Proxy (Proxy(..))

newtype Lounge = Lounge
  { title :: String
  , index :: Int
  , img :: String
  , unlocker :: Some Profile' -> Maybe Boolean
  }

pathToRealPath
  :: String
  -> List ((Some Profile' -> Maybe Boolean) /\ String)
  -> Profile
  -> String
pathToRealPath default arr (Profile p) = case actualized arr of
  Nothing -> default
  Just s -> s
  where
  actualized ((x /\ y) : z) = case x p of
    Just true -> actualized z
    _ -> Just y
  actualized Nil = Nothing

lounge
  :: forall lock payload
   . String
  -> Profile
  -> Lounge
  -> Domable lock payload
lounge path (Profile profile) (Lounge opts) = do
  let profileNotUnlocked = opts.unlocker profile /= Just true
  ionCard
    ( oneOf
        ( [ D.Disabled !:= profileNotUnlocked, klass_ "grow" ] <> guard
            (not profileNotUnlocked)
            [ D.Href !:= path ]
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
        , ionCardSubtitle_ [ text_ ("Track " <> show opts.index) ]
        ]
    ]

lounges :: Array Lounge
lounges =
  [ Lounge
      { title: "HYPERSYNTHETIC"
      , index: 1
      , img: catURL
      , unlocker: get (Proxy :: Proxy "hasCompletedTutorial")
      }
  , Lounge
      { title: "Show Me How"
      , index: 1
      , img: catURL
      , unlocker: get (Proxy :: Proxy "track2")
      }
  , Lounge
      { title: "LVL.99"
      , index: 1
      , img: catURL
      , unlocker: \p -> (&&)
          <$> get (Proxy :: Proxy "track3") p
          <*> get (Proxy :: Proxy "hasPaid") p
      }
  ]

loungePicker
  :: { profileState :: Event { profile :: Profile }
     }
  -> Effect Unit
loungePicker i = customComponent_ "lounge-picker" {}
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
        [ flip switcher i.profileState \{ profile } -> do
            let
              path = pathToRealPath "/you-won"
                ( (get (Proxy :: _ "flat") /\ "/equalize-level")
                    : (get (Proxy :: _ "buzz") /\ "/camera-level")
                    : (get (Proxy :: _ "glide") /\ "/glide-level")
                    : (get (Proxy :: _ "back") /\ "/back-level")
                    : (get (Proxy :: _ "track2") /\ "/lvlnn-level")
                    : (get (Proxy :: _ "rotate") /\ "/rotate-level")
                    : (get (Proxy :: _ "hide") /\ "/hide-level")
                    : (get (Proxy :: _ "dazzle") /\ "/dazzle-level")
                    : (get (Proxy :: _ "track3") /\ "/showmehow-level")
                    : (get (Proxy :: _ "crush") /\ "/crush-level")
                    : (get (Proxy :: _ "amplify") /\ "/amplify-level")
                    : Nil
                )
                profile
            D.div
              (oneOf [ klass_ "flex-col flex w-full h-full" ])
              [ D.div (klass_ "grow") []
              , D.div (klass_ "flex flex-row") (lounges <#> lounge path profile)
              , D.div (klass_ "grow") []
              ]
        ]
    ]
