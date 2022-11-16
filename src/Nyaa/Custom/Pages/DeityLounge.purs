module Nyaa.Custom.Pages.DeityLounge where

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

deityLounge :: { profileState :: Event { profile :: Profile } } -> Effect Unit
deityLounge { profileState } = lounge
  { name: "deity-lounge"
  , title: "LVL.99"
  , profileState
  , missions: [ Mission
          { title: "Killer Combo"
          , index: 10
          , description: D.span_
              [ text_ "Get a combo count of 143 to unlock the "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "CRUSH" ]
              , text_ " ability."
              ]
          , img: catURL
          , path: "/lvlnn-quest"
          , unlocker: get (Proxy :: _ "back")
          }
      , Mission
          { title: "Crush"
          , index: 11
          , description: D.span_
              [ text_ "Get 20,000 pts while "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "CRUSH" ]
              , text_ " is activated to get the "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "AMPLIFY" ]
              , text_ " ability."
              ]
          , img: catURL
          , path: "/crush-quest"
          , unlocker: get (Proxy :: _ "track1")
          }
      , Mission
          { title: "Amplify"
          , index: 8
          , description: D.span_
              [ text_ "Get 2,000 pts while "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "AMPLIFY" ]
              , text_ " is activated to get the "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "DAZZLE" ]
              , text_ " ability."
              ]
          , img: catURL
          , path: "/amplify-quest"
          , unlocker: get (Proxy :: _ "rotate")
          }
      ]
  }