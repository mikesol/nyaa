module Nyaa.Custom.Pages.ProfilePage where

import Prelude

import Control.Plus (empty)
import Data.Foldable (oneOf)
import Data.Nullable (Nullable)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import FRP.Event (Event)
import Nyaa.Firebase.Auth (User)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.BackButton (ionBackButton)
import Nyaa.Ionic.Buttons (ionButtons)
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent)
import Nyaa.Ionic.Enums (labelFloating)
import Nyaa.Ionic.Header (ionHeader)
import Nyaa.Ionic.Input (ionInput)
import Nyaa.Ionic.Item (ionItem_)
import Nyaa.Ionic.Label (ionLabel)
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)

-- avatar
-- username
-- achievements
-- invite

profilePage
  :: { authState :: Event { user :: Nullable User } }
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
                          [ D.Src !:=
                              "https://api.lorem.space/image/face?w=120&h=120&hash=bart89fe"
                          , D.Class !:= "rounded-full w-28 "
                          , D.Alt !:= "profile picture"
                          , D.Srcset !:= ""
                          ]
                      )
                      []
                  ]
              , D.div (D.Class !:= "w-fit mx-auto")
                  [
                    -- D.h2
                    --   ( D.Class !:=
                    --       "text-black font-bold text-2xl tracking-wide"
                    --   )
                    --   [ text_ "Jonathan Smith" ]
                    ionItem_
                      [ ionLabel (oneOf [I.Position !:= labelFloating, D.Class !:= "text-center"])
                          [ text_ "Jonathan Smith" ]
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
              ]
          ]
      ]
  ]