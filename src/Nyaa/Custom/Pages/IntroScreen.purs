module Nyaa.Custom.Pages.IntroScreen where

import Prelude

import Data.Foldable (oneOf)
import Data.Maybe (Maybe(..))
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (switcher, text_)
import Deku.Core (fixed)
import Deku.DOM as D
import Deku.Listeners (click_)
import Effect (Effect)
import Effect.Aff (launchAff_)
import FRP.Event (Event)
import Nyaa.Custom.Pages.DevAdmin (doScorelessAchievement, tutorialAchievement)
import Nyaa.Firebase.Firebase (Profile(..))
import Nyaa.Ionic.Button (ionButton)
import Nyaa.Ionic.Content (ionContent_)
import Nyaa.Ionic.Custom (customComponent_)
import Nyaa.SignIn (signInFlow)
import Nyaa.Some (get)
import Type.Proxy (Proxy(..))

introScreen
  :: { profileState :: Event { profile :: Maybe Profile }
     }
  -> Effect Unit
introScreen opts = customComponent_ "intro-screen" {} \_ ->
  [ ionContent_
      [ ionButton (oneOf [ D.Href !:= "/information-page", klass_ "absolute m-2",  D.Size !:= "small" ])
          [ text_ "?"
          ]
      , D.div
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
                  , flip switcher opts.profileState $ _.profile >>> do
                      let
                        playGame gameStartsAt =
                          [ ionButton
                              ( oneOf
                                  [ D.Href !:= gameStartsAt
                                  ]
                              )
                              [ text_ "Play" ]
                          ]
                      let
                        baseSignedIn =
                          [ ionButton
                              ( oneOf
                                  [ D.Href !:= "/tutorial-page"
                                  , click_ $ launchAff_ do
                                      doScorelessAchievement tutorialAchievement
                                  ]
                              )
                              [ text_ "Tutorial" ]
                          , ionButton (oneOf [ D.Href !:= "/profile-page" ])
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
                              fixed (playGame "/lounge-picker" <> baseSignedIn)
                          | get (Proxy :: _ "back") p == Just
                              true -> fixed (playGame "/lvlnn-quest" <> baseSignedIn)
                          | get (Proxy :: _ "glide") p == Just
                              true -> fixed (playGame "/back-quest" <> baseSignedIn)
                          | get (Proxy :: _ "buzz") p == Just
                              true -> fixed (playGame "/glide-quest" <> baseSignedIn)
                          | get (Proxy :: _ "flat") p == Just
                              true -> fixed (playGame "/buzz-quest" <> baseSignedIn)
                          | get (Proxy :: _ "track1") p == Just
                              true -> fixed (playGame "/flat-quest" <> baseSignedIn)
                          | otherwise -> fixed baseSignedIn
                  ]
              , D.div (oneOf [ klass_ "grow" ]) []
              ]
          , D.div (oneOf [ klass_ "grow" ]) []
          ]
      ]
  ]
