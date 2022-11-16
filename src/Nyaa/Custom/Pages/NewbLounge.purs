module Nyaa.Custom.Pages.NewbLounge where

import Prelude

import Data.Foldable (oneOf)
import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import FRP.Event (Event)
import Nyaa.Assets (catURL)
import Nyaa.Custom.Builders.Lounge (Mission(..), lounge)
import Nyaa.Firebase.Firebase (Profile)
import Nyaa.Some (get)
import Type.Proxy (Proxy(..))

newbLounge :: { profileState :: Event { profile :: Profile } } -> Effect Unit
newbLounge { profileState } = lounge
  { name: "newb-lounge"
  , title: "HYPERSYNTHETIC"
  , profileState
  , missions:
      [ Mission
          { title: "Killer Combo"
          , index: 1
          , description: D.span_
              [ text_ "Get a combo count of 143 to unlock the "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "FLAT" ]
              , text_ " ability."
              ]
          , img: catURL
          , path: "/hypersynthetic-quest"
          , unlocker: get (Proxy :: _ "hasCompletedTutorial")
          }
      , Mission
          { title: "Flat"
          , index: 2
          , description: D.span_
              [ text_ "Get 20,000 pts while "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "FLAT" ]
              , text_ " is activated to get the "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "BUZZ" ]
              , text_ " ability."
              ]
          , img: catURL
          , path: "/flat-quest"
          , unlocker: get (Proxy :: _ "flat")
          }
      , Mission
          { title: "Buzz"
          , index: 3
          , description: D.span_
              [ text_ "Get 2,000 pts while "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "BUZZ" ]
              , text_ " is activated to get the "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "GLIDE" ]
              , text_ " ability."
              ]
          , img: catURL
          , path: "/buzz-quest"
          , unlocker: get (Proxy :: _ "buzz")
          }
      , Mission
          { title: "Glide"
          , index: 4
          , description: D.span_
              [ text_ "Get 4,000 pts while "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "GLIDE" ]
              , text_ " is activated to get the "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "BACK" ]
              , text_ " ability."
              ]
          , img: catURL
          , path: "/glide-quest"
          , unlocker: get (Proxy :: _ "glide")
          }
      , Mission
          { title: "Back"
          , index: 5
          , description: D.span_
              [ text_ "Get 6,000 pts while "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "BACK" ]
              , text_ " is activated to "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "LEVEL UP" ]
              , text_ "!"
              ]
          , img: catURL
          , path: "/back-quest"
          , unlocker: get (Proxy :: _ "back")
          }
      ]
  }