module Nyaa.App where

import Data.Foldable (oneOf)
import Deku.Attribute ((!:=))
import Deku.Core (Domable)
import Nyaa.Ionic.App (ionApp_)
import Nyaa.Ionic.Attributes as D
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Nav (ionNav_)
import Nyaa.Ionic.Route (ionRoute)
import Nyaa.Ionic.Router (ionRouter_)

app :: forall lock payload. Domable lock payload
app = ionApp_
  [ ionRouter_
      [ ionRoute (oneOf [ D.Url !:= "/", I.Component !:= "listum-ipsum" ]) []
      , ionRoute (oneOf [ D.Url !:= "/info-one", I.Component !:= "info-one" ]) []
      , ionRoute (oneOf [ D.Url !:= "/info-two", I.Component !:= "info-two" ]) []

      ]
  , ionNav_ []
  ]