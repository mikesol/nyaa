module Nyaa.Custom.Pages.IntroScreen where

import Prelude

import Data.Foldable (oneOf)
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toMaybe)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (switcher, text_)
import Deku.Core (fixed)
import Deku.DOM as D
import Deku.Listeners (click_)
import Effect (Effect)
import Effect.Aff (launchAff_)
import FRP.Event (Event)
import Nyaa.Firebase.Auth (User)
import Nyaa.Ionic.Button (ionButton)
import Nyaa.Ionic.Content (ionContent_)
import Nyaa.Ionic.Custom (customComponent)
import Nyaa.SignIn (signInFlow, signOutFlow)

introScreen
  :: { authState :: Event { user :: Nullable User } }
  -> Effect Unit
introScreen opts = customComponent "intro-screen" {} \_ ->
  [ ionContent_
      [ D.div (oneOf [ klass_ "flex flex-col justify-between w-full h-full" ])
          [ D.div (oneOf [ klass_ "grow" ]) []
          , D.div (oneOf [ klass_ "flex flex-row" ])
              [ D.div (oneOf [ klass_ "grow" ]) []
              , D.div (oneOf [])
                  [ D.div_
                      [ D.h1 (oneOf [ klass_ "text-center" ]) [ text_ "Nyā" ] ]
                  , ionButton (oneOf [ D.Href !:= "/tutorial-quest" ])
                      [ text_ "Tutorial" ]
                  , flip switcher opts.authState $ _.user >>> toMaybe >>>
                      case _ of
                        Nothing -> fixed
                          [ ionButton (click_ (launchAff_ signInFlow))
                              [ text_ "Sign in" ]
                          ]
                        Just _ -> fixed
                          [ ionButton (oneOf [ D.Href !:= "/profile-page" ])
                              [ text_ "Profile" ]
                          , ionButton (click_ (launchAff_ signOutFlow))
                              [ text_ "Sign out" ]
                          ]
                  ]
              , D.div (oneOf [ klass_ "grow" ]) []
              ]
          , D.div (oneOf [ klass_ "grow" ]) []
          ]
      ]
  ]