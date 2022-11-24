module Nyaa.Custom.Pages.LoungePicker where

import Prelude

import Control.Promise (toAffE)
import Data.Either (Either(..))
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
import Deku.Listeners (click_)
import Effect (Effect)
import Effect.Aff (catchError, launchAff_, makeAff)
import FRP.Event (Event)
import Nyaa.Assets (catURL)
import Nyaa.Firebase.Firebase (Profile(..), Profile', genericUpdate)
import Nyaa.Ionic.Alert (alert)
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
import Nyaa.Ionic.Icon (ionIcon)
import Nyaa.Ionic.Loading (brackedWithLoading)
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)
import Nyaa.Money as Money
import Nyaa.Some (Some, get, some)
import Type.Proxy (Proxy(..))

newtype Lounge = Lounge
  { title :: String
  , index :: Int
  , img :: String
  , path :: Profile -> String
  , isBehindPaywall :: Boolean
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
   . Boolean
  -> Profile
  -> Lounge
  -> Domable lock payload
lounge isWeb pfl@(Profile profile) (Lounge opts) = do
  let profileNotUnlocked = opts.unlocker profile /= Just true
  let profileUnlocked = not profileNotUnlocked
  let hasntPaidYet = get (Proxy :: Proxy "hasPaid") profile /= Just true
  let hasPaid = not hasntPaidYet
  ionCard
    ( oneOf
        ( [ D.Disabled !:= profileNotUnlocked, klass_ "grow cursor-pointer" ]
            <> guard
              ( (not opts.isBehindPaywall && profileUnlocked)
                  || (profileUnlocked && hasPaid)
                  || isWeb
              )
              [ D.Href !:= opts.path pfl ]
            <> guard
              ( profileUnlocked && hasntPaidYet && not isWeb &&
                  opts.isBehindPaywall
              )
              [ click_ $ launchAff_ do
                  alert "Achieve Greatness" Nothing
                    ( Just
                        "Purchase the last track to access the best music and effects yet!"
                    )
                    [ { text: "Not yet", handler: pure unit }
                    , { text: "I need this"
                      , handler: launchAff_ $ brackedWithLoading
                          "Get ready for sick ear candy!"
                          do
                            makeAff \cb -> do
                              Money.buy
                                ( do
                                    cb (Right unit)
                                    launchAff_ do
                                      alert "Uh oh..." Nothing
                                        ( Just
                                            "We couldn't process your payment 😳 Please try again."
                                        )
                                        [ { text: "OK"
                                          , handler: pure unit
                                          }
                                        ]
                                )
                                ( do
                                    cb (Right unit)
                                    launchAff_ do
                                      toAffE $ genericUpdate
                                        (Profile (some { hasPaid: true }))
                                      alert "Nice!" Nothing
                                        ( Just
                                            "You've unlocked the final track 🎉"
                                        )
                                        [ { text: "Game on"
                                          , handler: pure unit
                                          }
                                        ]
                                )
                              pure mempty
                      }
                    ]
              ]
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
        ( guard (opts.isBehindPaywall && not isWeb)
            [ ionIcon
                ( oneOf
                    [ D.Name !:=
                        ( if hasntPaidYet then "lock-closed-outline"
                          else "lock-open-outline"
                        )
                    , D.Size !:= "small"
                    , D.Class !:= "absolute -mt-4 cursor-pointer"
                    ]
                )
                []
            ] <>
            [ ionCardTitle_ [ text_ opts.title ]
            , ionCardSubtitle_
                [ D.div (klass_ "flex flex-row justify-between")
                    ( [ D.div_ [ text_ ("Track " <> show opts.index) ] ] <>
                        guard
                          ( profileUnlocked && hasntPaidYet && not isWeb &&
                              opts.isBehindPaywall
                          )
                          [ D.a
                              ( oneOf
                                  [ click_ do
                                      launchAff_ $ brackedWithLoading
                                        "Verifying payment"
                                        do
                                          catchError
                                            ( do
                                                toAffE Money.refreshStatus
                                                toAffE $ genericUpdate
                                                  ( Profile
                                                      (some { hasPaid: true })
                                                  )
                                            )
                                            \_ -> do
                                              alert "Apologies!" Nothing
                                                ( Just
                                                    "We could not confirm your payment. Contact support@joyride.fm."
                                                )
                                                [ { text: "OK"
                                                  , handler: pure unit
                                                  }
                                                ]
                                  ]
                              )
                              [ text_ "Refresh" ]
                          ]
                    )
                ]
            ]
        )
    ]

lounges :: Array Lounge
lounges =
  [ Lounge
      { title: "HYPERSYNTHETIC"
      , index: 1
      , img: catURL
      , isBehindPaywall: false
      , unlocker: get (Proxy :: Proxy "track1")
      , path: pathToRealPath "/hypersyntheticdone-quest"
          ( (get (Proxy :: _ "flat") /\ "/equalize-quest")
              : (get (Proxy :: _ "buzz") /\ "/camera-quest")
              : (get (Proxy :: _ "glide") /\ "/glide-quest")
              : (get (Proxy :: _ "back") /\ "/back-quest")
              : (get (Proxy :: _ "track2") /\ "/lvlnn-quest")
              : Nil
          )
      }
  , Lounge
      { title: "LVL.99"
      , index: 2
      , img: catURL
      , isBehindPaywall: false
      , unlocker: get (Proxy :: Proxy "track2")
      , path: pathToRealPath "/lvlnndone-quest"
          ( (get (Proxy :: _ "flat") /\ "/equalize-quest")
              : (get (Proxy :: _ "buzz") /\ "/camera-quest")
              : (get (Proxy :: _ "glide") /\ "/glide-quest")
              : (get (Proxy :: _ "back") /\ "/back-quest")
              : (get (Proxy :: _ "track2") /\ "/lvlnn-quest")
              : (get (Proxy :: _ "rotate") /\ "/rotate-quest")
              : (get (Proxy :: _ "hide") /\ "/hide-quest")
              : (get (Proxy :: _ "dazzle") /\ "/dazzle-quest")
              : (get (Proxy :: _ "track3") /\ "/showmehow-quest")
              : Nil
          )
          
      }
  , Lounge
      { title: "Show Me How"
      , index: 3
      , isBehindPaywall: true
      , img: catURL
      , unlocker: get (Proxy :: Proxy "track3")
      , path: pathToRealPath "/youwon-quest"
          ( (get (Proxy :: _ "flat") /\ "/equalize-quest")
              : (get (Proxy :: _ "buzz") /\ "/camera-quest")
              : (get (Proxy :: _ "glide") /\ "/glide-quest")
              : (get (Proxy :: _ "back") /\ "/back-quest")
              : (get (Proxy :: _ "track2") /\ "/lvlnn-quest")
              : (get (Proxy :: _ "rotate") /\ "/rotate-quest")
              : (get (Proxy :: _ "hide") /\ "/hide-quest")
              : (get (Proxy :: _ "dazzle") /\ "/dazzle-quest")
              : (get (Proxy :: _ "track3") /\ "/showmehow-quest")
              : (get (Proxy :: _ "crush") /\ "/crush-quest")
              : (get (Proxy :: _ "amplify") /\ "/amplify-quest")
              : Nil
          )
          
      }
  ]

loungePicker
  :: { profileState :: Event { profile :: Profile }
     , isWeb :: Boolean
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
            D.div
              (oneOf [ klass_ "flex-col flex w-full h-full" ])
              [ D.div (klass_ "grow") []
              , D.div (klass_ "flex flex-row")
                  (lounges <#> lounge i.isWeb profile)
              , D.div (klass_ "grow")
                  [ D.h2 (klass_ "text-center")
                      [ D.span (oneOf []) [ text_ "Music by " ]
                      , D.a
                          ( oneOf
                              [ D.Href !:= "https://twitter.com/akiracomplex"
                              , D.Target !:= "blank_"
                              ]
                          )
                          [ text_ " Akira Complex " ]
                      ]
                  ]
              ]
        ]
    ]
