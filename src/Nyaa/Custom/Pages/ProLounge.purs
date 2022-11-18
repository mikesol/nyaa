module Nyaa.Custom.Pages.ProLounge where

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

proLounge :: { profileState :: Event { profile :: Profile } } -> Effect Unit
proLounge { profileState } = lounge
  { name: "pro-lounge"
  , title: "Show Me How"
  , profileState
  , missions:
      [ Mission
          { title: "Killer Combo"
          , index: 6
          , description: D.span_
              [ text_ "Get a combo count of 143 to unlock the "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "ROTATE" ]
              , text_ " ability."
              ]
          , img: catURL
          , path: "/showmehow-quest"
          , unlocker: get (Proxy :: _ "back")
          }
      , Mission
          { title: "Rotate"
          , index: 7
          , description: D.span_
              [ text_ "Get 20,000 pts while "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "ROTATE" ]
              , text_ " is activated to get the "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "HIDE" ]
              , text_ " ability."
              ]
          , img: catURL
          , path: "/rotate-quest"
          , unlocker: get (Proxy :: _ "track1")
          }
      , Mission
          { title: "Hide"
          , index: 8
          , description: D.span_
              [ text_ "Get 2,000 pts while "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "HIDE" ]
              , text_ " is activated to get the "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "DAZZLE" ]
              , text_ " ability."
              ]
          , img: catURL
          , path: "/hide-quest"
          , unlocker: get (Proxy :: _ "rotate")
          }
      , Mission
          { title: "Dazzle"
          , index: 9
          , description: D.span_
              [ text_ "Get 4,000 pts while "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "DAZZLE" ]
              , text_ " is activated to "
              , D.span (oneOf [ klass_ "font-bold" ]) [ text_ "LEVEL UP" ]
              , text_ "!"
              ]
          , img: catURL
          , path: "/dazzle-quest"
          , unlocker: get (Proxy :: _ "hide")
          }
      ]
  }