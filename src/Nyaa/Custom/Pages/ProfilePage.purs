module Nyaa.Custom.Pages.ProfilePage where

import Prelude

import Control.Alt ((<|>))
import Control.Plus (empty)
import Control.Promise (toAffE)
import Data.Compactable (compact)
import Data.Foldable (oneOf)
import Data.Maybe (Maybe(..))
import Data.Newtype (unwrap)
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested ((/\))
import Deku.Attribute ((!:=), (:=))
import Deku.Attributes (klass_)
import Deku.Control (blank, switcher, text, text_)
import Deku.Core (Domable, envy)
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Listeners (click, click_)
import Effect (Effect)
import Effect.Aff (Aff, bracket, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import FRP.Event (Event)
import Nyaa.Assets (catURL)
import Nyaa.Capacitor.Camera (takePicture)
import Nyaa.Capacitor.FriendsPlugin (sendFriendRequest)
import Nyaa.Capacitor.Utils (Platform(..), getPlatformE)
import Nyaa.Constants.PlayGames as PGConstants
import Nyaa.FRP.Dedup (dedup)
import Nyaa.FRP.First (first)
import Nyaa.FRP.MemoBeh (useMemoBeh)
import Nyaa.Firebase.Firebase (Profile(..), updateAvatarUrl, updateName, uploadAvatar)
import Nyaa.GameCenter as GC
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.BackButton (ionBackButton)
import Nyaa.Ionic.Button (ionButton)
import Nyaa.Ionic.Buttons (ionButtons)
import Nyaa.Ionic.Card (ionCard)
import Nyaa.Ionic.CardHeader (ionCardHeader_)
import Nyaa.Ionic.CardTitle (ionCardTitle_)
import Nyaa.Ionic.Col (ionCol)
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent_)
import Nyaa.Ionic.Enums (buttonexpandBlock, buttonexpandFull, danger, labelStacked)
import Nyaa.Ionic.Grid (ionGrid_)
import Nyaa.Ionic.Header (ionHeader, ionHeader_)
import Nyaa.Ionic.Icon (ionIcon)
import Nyaa.Ionic.Input (getInputElement, ionInput)
import Nyaa.Ionic.Item (ionItem_)
import Nyaa.Ionic.Label (ionLabel)
import Nyaa.Ionic.Loading (brackedWithLoading, dismissLoading, presentLoading)
import Nyaa.Ionic.Modal (dismiss, ionModal, present)
import Nyaa.Ionic.Row (ionRow_)
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)
import Nyaa.PlayGames as PG
import Nyaa.SignIn (signOutFlow)
import Nyaa.Some (get)
import Simple.JSON as JSON
import Type.Proxy (Proxy(..))
import Web.HTML.HTMLInputElement (value)

-- avatar
-- username
-- achievements
-- invite

changeAvatar ∷ Aff Unit
changeAvatar = do
  tookPicture <- toAffE takePicture
  bracket (toAffE $ presentLoading "Uploading photo")
    (toAffE <<< dismissLoading)
    \_ -> do
      avatarUrl <- toAffE $ uploadAvatar tookPicture.buffer
      toAffE $ updateAvatarUrl { avatarUrl }

achievement
  :: forall lock payload
   . { earned :: Event Boolean, title :: String }
  -> Domable lock payload
achievement opts = ionCard (oneOf [ opts.earned <#> not <#> (D.Disabled := _) ])
  [ D.img
      ( oneOf
          [ D.Alt !:= "Silhouette of mountains"
          , D.Src !:= catURL
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
  :: { clearProfile :: Effect Unit
     , platform :: Platform
     , profileState :: Event { profile :: Profile }
     }
  -> Effect Unit
profilePage opts = customComponent_ "profile-page" {} \_ ->
  [ ionHeader (oneOf [ I.Translucent !:= true ])
      [ ionToolbar_
          [ ionButtons (oneOf [ I.Slot !:= "start" ])
              [ ionBackButton (oneOf [ I.DefaultHref !:= "/" ]) []
              ]
          , ionTitle_ [ text_ "Profile" ]
          ]
      ]
  , Deku.do
      setModalComponent /\ modalComponent <- useMemoBeh
      setNameInputComponent /\ nameInputComponent <- useMemoBeh
      ionContent (oneOf [ klass_ "ion-padding", I.Fullscren !:= true ])
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
                ( [ D.div (D.Class !:= "mt-6 w-fit mx-auto")
                      [ D.img
                          ( oneOf
                              [ let
                                  strm = compact
                                    ( opts.profileState <#>
                                        ( _.profile >>> unwrap >>> get
                                            (Proxy :: _ "avatarUrl")
                                        )
                                    )
                                in
                                  -- a bit expensive
                                  -- can optimize later
                                  ( dedup
                                      (strm <|> (first (strm <|> pure catURL)))
                                  )
                                    <#> (D.Src := _)
                              , D.Class !:= "rounded-full w-28"
                              , D.Alt !:= "profile picture"
                              , D.Srcset !:= ""
                              , click_ (launchAff_ changeAvatar)
                              ]
                          )
                          []
                      , ionIcon
                          ( oneOf
                              [ D.Name !:= "camera-reverse-outline"
                              , D.Size !:= "small"
                              , D.Class !:= "absolute -mt-4 cursor-pointer"
                              , click_ (launchAff_ changeAvatar)
                              ]
                          )
                          []
                      ]
                  , D.h1
                      ( oneOf
                          [ klass_ "text-center text-2xl pt-2"
                          , click $ modalComponent <#> \mc -> launchAff_ do
                              toAffE $ present mc
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
                      , ionIcon
                          ( oneOf
                              [ D.Name !:= "pencil"
                              , D.Size !:= "small"
                              , D.Class !:= "ml-2 cursor-pointer"
                              , click $ modalComponent <#> \mc -> launchAff_ do
                                  toAffE $ present mc
                              ]
                          )
                          []
                      ]
                  ] <>
                    case opts.platform of
                      IOS ->
                        [ ionGrid_
                            [ ionRow_
                                [ ionCol (oneOf [ klass_ "ion-text-center" ])
                                    [ ionButton
                                        ( oneOf
                                            [ click_ $ launchAff_ do
                                                toAffE $ GC.showGameCenter
                                                  { state: "achievements" }
                                            ]
                                        )
                                        [ text_ "Achievements" ]
                                    ]
                                , ionCol (oneOf [ klass_ "ion-text-center" ])
                                    [ ionButton
                                        ( oneOf
                                            [ click_ $ launchAff_ do
                                                toAffE $ GC.showGameCenter
                                                  { state: "leaderboards" }
                                            ]
                                        )
                                        [ text_ "Leaderboards" ]
                                    ]
                                , ionCol (oneOf [ klass_ "ion-text-center" ])
                                    [ ionButton
                                        ( oneOf
                                            [ click_ $ launchAff_ do
                                                toAffE $ GC.showGameCenter
                                                  { state:
                                                      "localPlayerFriendsList"
                                                  }
                                            ]
                                        )
                                        [ text_ "Friends" ]
                                    ]
                                ]
                            ]
                        ]
                      Android ->
                        [ ionButton
                            ( oneOf
                                [ click_ $ launchAff_ do
                                    toAffE PG.showAchievements
                                , I.Expand !:= buttonexpandFull
                                ]
                            )
                            [ text_ "Achievements" ]
                        , D.div (D.Class !:= "w-fit mx-auto")
                            [ D.h2
                                ( D.Class !:=
                                    "font-bold text-2xl tracking-wide"
                                )
                                [ text_ "Leaderboards" ]
                            ]
                        , ionGrid_
                            [ ionRow_
                                [ ionCol (oneOf [ klass_ "ion-text-center" ])
                                    [ ionButton
                                        ( oneOf
                                            [ click_ $ launchAff_ do
                                                toAffE $ PG.showLeaderboard
                                                  { leaderboardID:
                                                      PGConstants.track1LeaderboardID
                                                  }
                                            ]
                                        )
                                        [ text_ "Track 1" ]
                                    ]
                                , ionCol (oneOf [ klass_ "ion-text-center" ])
                                    [ ionButton
                                        ( oneOf
                                            [ click_ $ launchAff_ do
                                                toAffE $ PG.showLeaderboard
                                                  { leaderboardID:
                                                      PGConstants.track2LeaderboardID
                                                  }
                                            ]
                                        )
                                        [ text_ "Track 2" ]
                                    ]
                                , ionCol (oneOf [ klass_ "ion-text-center" ])
                                    [ ionButton
                                        ( oneOf
                                            [ click_ $ launchAff_ do
                                                toAffE $ PG.showLeaderboard
                                                  { leaderboardID:
                                                      PGConstants.track3LeaderboardID
                                                  }
                                            ]
                                        )
                                        [ text_ "Track 3" ]
                                    ]
                                ]
                            ]
                        ]
                      Web ->
                        [ D.div (D.Class !:= "w-fit mx-auto")
                            [ D.h2
                                ( D.Class !:=
                                    "font-bold text-2xl tracking-wide"
                                )
                                [ text_ "Achievements" ]
                            ]
                        , flip switcher opts.profileState
                            \{ profile: Profile profile } -> do
                              let
                                store =
                                  [ get (Proxy :: _ "hasCompletedTutorial")
                                      profile /\ "Tutorial"
                                  , get (Proxy :: _ "track1")
                                      profile /\ "HYPERSYNTHETIC"
                                  , get (Proxy :: _ "flat")
                                      profile /\ "Flat"
                                  , get (Proxy :: _ "buzz")
                                      profile /\ "Buzz"
                                  , get (Proxy :: _ "glide")
                                      profile /\ "Glide"
                                  , get (Proxy :: _ "back")
                                      profile /\ "Back"
                                  , get (Proxy :: _ "track2")
                                      profile /\ "Show Me How"
                                  , get (Proxy :: _ "rotate")
                                      profile /\ "Rotate"
                                  , get (Proxy :: _ "hide")
                                      profile /\ "Hide"
                                  , get (Proxy :: _ "dazzle")
                                      profile /\ "Dazzle"
                                  , get (Proxy :: _ "track3")
                                      profile /\ "LVL.99"
                                  , get (Proxy :: _ "crush")
                                      profile /\ "Crush"
                                  , get (Proxy :: _ "amplify")
                                      profile /\ "Amplify"
                                  ]
                              D.div
                                (D.Class !:= "grid grid-cols-4 gap-4")
                                (store <#> \(earned /\ title) -> achievement
                                { earned: pure (earned == Just true), title })
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
                                  , D.span (klass_ "font-bold")
                                      [ text_ "Profile" ]
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
                        ] <>
                          [ ionButton
                              ( oneOf
                                  [ D.Href !:= "/"
                                  , D.Color !:= danger
                                  , I.Expand !:= buttonexpandBlock
                                  , click_
                                      ( launchAff_
                                          ( signOutFlow
                                              { clearProfile: opts.clearProfile
                                              }
                                          )
                                      )
                                  ]
                              )
                              [ text_ "Sign out" ]
                          ]
                )
            ]
        , ionModal
            ( oneOf
                [ D.SelfT !:= \i -> do
                    log "setting modal component"
                    setModalComponent i
                ]
            )
            [ ionHeader_
                [ ionToolbar_
                    [ ionButtons (I.Slot !:= "start")
                        [ ionButton
                            ( oneOf
                                [ ( click $ modalComponent <#> \mc -> launchAff_
                                      do
                                        void $ toAffE $ dismiss mc
                                          (JSON.write {})
                                          "cancel"
                                  )
                                ]
                            )
                            [ text_ "Cancel" ]
                        ]
                    , ionTitle_ [ text_ "Welcome" ]
                    , ionButtons (I.Slot !:= "end")
                        [ ionButton
                            ( oneOf
                                [ ( click $
                                      ( Tuple <$> modalComponent <*>
                                          nameInputComponent
                                      ) <#> \(mc /\ nic) -> launchAff_ do
                                        brackedWithLoading "Updating profile..."
                                          do
                                            ipt <- toAffE $ getInputElement nic
                                            username <- liftEffect $ value ipt
                                            toAffE $ updateName { username }
                                            void $ toAffE $ dismiss mc
                                              (JSON.write {})
                                              "confirm"
                                  )
                                ]
                            )
                            [ text_ "Confirm" ]
                        ]
                    ]
                ]
            , ionContent (D.Class !:= "ion-padding")
                [ ionItem_
                    [ ionLabel (I.Position !:= labelStacked)
                        [ text_ "Enter your name" ]
                    , ionInput
                        ( oneOf
                            [ D.Placeholder !:= "Your name"
                            , D.SelfT !:= setNameInputComponent
                            ]
                        )
                        []
                    ]
                ]
            ]
        ]
  ]
