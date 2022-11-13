module Nyaa.Custom.Pages.ProfilePage where

import Prelude

import Control.Plus (empty)
import Control.Promise (toAffE)
import Data.Compactable (compact)
import Data.Foldable (oneOf)
import Data.Newtype (unwrap)
import Deku.Attribute ((!:=), (:=))
import Deku.Attributes (klass_)
import Deku.Control (blank, text, text_)
import Deku.Core (Domable, envy)
import Deku.DOM as D
import Deku.Listeners (click_)
import Effect (Effect)
import Effect.Aff (launchAff_)
import FRP.Event (Event)
import Nyaa.Assets (catURL)
import Nyaa.Capacitor.FriendsPlugin (sendFriendRequest)
import Nyaa.Capacitor.Utils (Platform(..), getPlatformE)
import Nyaa.FRP.Race (race)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.BackButton (ionBackButton)
import Nyaa.Ionic.Button (ionButton)
import Nyaa.Ionic.Buttons (ionButtons)
import Nyaa.Ionic.Card (ionCard)
import Nyaa.Ionic.CardHeader (ionCardHeader_)
import Nyaa.Ionic.CardTitle (ionCardTitle_)
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent)
import Nyaa.Ionic.Enums (labelFloating)
import Nyaa.Ionic.Header (ionHeader)
import Nyaa.Ionic.Input (ionInput)
import Nyaa.Ionic.Item (ionItem_)
import Nyaa.Ionic.Label (ionLabel)
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)
import Nyaa.Some (get)
import Type.Proxy (Proxy(..))

-- avatar
-- username
-- achievements
-- invite

achievement
  :: forall lock payload
   . { earned :: Event Boolean, title :: String }
  -> Domable lock payload
achievement opts = ionCard (oneOf [ opts.earned <#> not <#> (D.Disabled := _) ])
  [ D.img
      ( oneOf
          [ D.Alt !:= "Silhouette of mountains"
          , D.Src !:= "https://ionicframework.com/docs/img/demos/card-media.png"
          ]
      )
      []
  , ionCardHeader_
      [ ionCardTitle_ [ text_ opts.title ]
      -- , ionCardSubtitle_ [ text_ "Card Subtitle" ]
      ]
  -- , ionCardContent_
  --     [ text_
  --         "Here's a small text description for the card content. Nothing more, nothing less.\n  "
  --     ]
  ]

profilePage
  :: { profileState :: Event { profile :: Profile } }
  -> Effect Unit
profilePage opts = customComponent "profile-page" {} \_ ->
  [ ionHeader (oneOf [ I.Translucent !:= true ])
      [ ionToolbar_
          [ ionButtons (oneOf [ I.Slot !:= "start" ])
              [ ionBackButton (oneOf [ I.DefaultHref !:= "/" ]) []
              ]
          , ionTitle_ [ text_ "Profile" ]
          ]
      ]
  , ionContent (oneOf [ klass_ "ion-padding", I.Fullscren !:= true ])
      [ D.section
          ( oneOf
              [ D.Style !:= "" -- "font-family: Montserrat"
              , D.Class !:=
                  ""
              ]
          )
          [ D.section
              ( D.Class !:=
                  "w-full mx-auto px-8 py-6 "
              )
              [ D.div (D.Class !:= "mt-6 w-fit mx-auto")
                  [ D.img
                      ( oneOf
                          [ race ( compact
                                ( opts.profileState <#>
                                    ( _.profile >>> unwrap >>> get
                                        (Proxy :: _ "avatarUrl")
                                    )
                                )

                            ) (pure catURL) <#> (D.Src := _)

                          , D.Class !:= "rounded-full w-28"
                          , D.Alt !:= "profile picture"
                          , D.Srcset !:= ""
                          ]
                      )
                      []
                  ]
              , D.div (D.Class !:= "w-fit mx-auto")
                  [ ionItem_
                      [ ionLabel
                          ( oneOf
                              [ I.Position !:= labelFloating
                              , D.Class !:= "text-center"
                              ]
                          )
                          [ text
                              ( compact
                                  ( opts.profileState <#>
                                      ( _.profile >>> unwrap >>> get
                                          (Proxy :: _ "username")
                                      )
                                  )

                              )
                          ]
                      , ionInput (D.Placeholder !:= "Your name") []
                      ]
                  ]
              , D.div (D.Class !:= "w-fit mx-auto")
                  [ D.h2
                      ( D.Class !:=
                          "font-bold text-2xl tracking-wide"
                      )
                      [ text_ "Achievements" ]
                  ]
              , D.div (D.Class !:= "grid grid-cols-4 gap-4")
                  [ achievement { earned: pure true, title: "Tutorial" }
                  , achievement { earned: pure true, title: "Track 1" }
                  , achievement { earned: pure true, title: "Flat" }
                  , achievement { earned: pure true, title: "Buzz" }
                  , achievement { earned: pure true, title: "Glide" }
                  , achievement { earned: pure false, title: "Back" }
                  , achievement { earned: pure false, title: "Track 2" }
                  , achievement { earned: pure false, title: "Rotate" }
                  , achievement { earned: pure false, title: "Hide" }
                  , achievement { earned: pure false, title: "Dazzle" }
                  , achievement { earned: pure false, title: "Track 3" }
                  , achievement { earned: pure false, title: "Crush" }
                  , achievement { earned: pure false, title: "Amplify" }
                  , achievement { earned: pure false, title: "Nyā" }
                  , achievement { earned: pure false, title: "Nyāā" }
                  , achievement { earned: pure false, title: "Nyāāā" }
                  ]
              , envy $ getPlatformE <#> case _ of
                  Web -> blank
                  Android -> D.div empty
                    [ D.h2
                        ( D.Class !:=
                            "font-bold text-2xl tracking-wide"
                        )
                        [ text_ "Nyā + Friends = ❤️" ]
                    , D.p_
                        [ text_ "In Play Games, go to the "
                        , D.span (klass_ "font-bold") [ text_ "Profile" ]
                        , text_ " page and invite your friends!"
                        ]
                    , ionButton
                        ( oneOf
                            [ click_ do
                                launchAff_ $ toAffE sendFriendRequest
                            , klass_ "mt-4"
                            ]
                        )
                        [ text_ "Open Play Games" ]
                    , ionButton (oneOf [ klass_ "mt-4" ])
                        [ text_ "Share Nyā" ]
                    ]
                  IOS -> D.div empty
                    [ D.h2
                        ( D.Class !:=
                            "font-bold text-2xl tracking-wide"
                        )
                        [ text_ "Nyā + Friends = ❤️" ]
                    , D.p_ []
                    , ionButton
                        ( oneOf
                            [ click_ do
                                launchAff_ $ toAffE sendFriendRequest
                            , klass_ "mt-4"
                            ]
                        )
                        [ text_ "Send a Message from Game Center" ]
                    , ionButton (oneOf [ klass_ "mt-4" ])
                        [ text_ "Share Nyā" ]
                    ]

              ]
          ]
      ]
  ]