module Nyaa.Custom.Pages.IntroScreen where

import Prelude

import Data.Foldable (oneOf)
import Data.Maybe (Maybe(..))
import Debug (spy)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (switcher, text_)
import Deku.Core (fixed)
import Deku.DOM as D
import Deku.Listeners (click_)
import Effect (Effect)
import Effect.Aff (launchAff_)
import FRP.Event (Event)
import Nyaa.Firebase.Firebase (Profile(..))
import Nyaa.Ionic.Button (ionButton)
import Nyaa.Ionic.Content (ionContent_)
import Nyaa.Ionic.Custom (customComponent_)
import Nyaa.SignIn (signInFlow)
import Nyaa.Some (get)
import Type.Proxy (Proxy(..))

data GameStartsAt = NewbTrack | TrackPicker

introScreen
  :: { profileState :: Event { profile :: Maybe Profile }
     }
  -> Effect Unit
introScreen opts = customComponent_ "intro-screen" {} \_ ->
  [ ionContent_
      [ D.div
          ( oneOf
              [ klass_
                  "bg-beach bg-center bg-cover flex flex-col justify-between w-full h-full"
              ]
          )
          [ D.div (oneOf [ klass_ "grow" ]) []
          , D.div (oneOf [ klass_ "flex flex-row" ])
              [ D.div (oneOf [ klass_ "grow" ]) []
              , D.div (oneOf [])
                  [ D.div_
                      [ D.h1 (oneOf [ klass_ "moichy-font text-center" ])
                          [ text_ "Nya" ]
                      ] -- "Nyā"
                  , ionButton (oneOf [ D.Href !:= "/tutorial-quest" ])
                      [ text_ "Tutorial" ]
                  , flip switcher opts.profileState $ _.profile >>> do
                      let
                        playGame gameStartsAt =
                          [ ionButton
                              ( oneOf
                                  [ D.Href !:= case gameStartsAt of
                                      NewbTrack -> "/newb-lounge"
                                      TrackPicker -> "/lounge-picker"
                                  ]
                              )
                              [ text_ "Play" ]
                          ]
                      let
                        baseSignedIn =
                          [ ionButton (oneOf [ D.Href !:= "/profile-page" ])
                              [ text_ "Profile" ]
                          ]
                      case _ of
                        Nothing -> fixed
                          [ ionButton
                              ( click_
                                  (launchAff_ signInFlow)
                              )
                              [ text_ "Sign in" ]
                          ]
                        Just (Profile p)
                          -- if track 2 is unlocked, then by definition we can 
                          -- go to the track picker
                          | get (Proxy :: _ "track2") p == Just
                              true ->
                              fixed (playGame TrackPicker <> baseSignedIn)
                          | get (Proxy :: _ "hasCompletedTutorial") p == Just
                              true ->
                              let
                                _ = spy "newb" p
                              in
                                fixed (playGame NewbTrack <> baseSignedIn)
                          | otherwise ->
                              let _ = spy "newb" p in fixed baseSignedIn
                  ]
              , D.div (oneOf [ klass_ "grow" ]) []
              ]
          , D.div (oneOf [ klass_ "grow" ]) []
          ]
      ]
  ]
