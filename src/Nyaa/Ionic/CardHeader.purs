module Nyaa.Ionic.CardHeader where

import Control.Plus (empty)
import Deku.Attribute (class Attr, Attribute, prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (unsafeCustomElement)
import Deku.DOM as D
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Enums as E
import Type.Proxy (Proxy(..))

data IonCardHeader_
data IonCardHeader

ionCardHeader
  :: forall lock payload
   . Event (Attribute IonCardHeader_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionCardHeader = unsafeCustomElement "ion-card-header"
  (Proxy :: Proxy IonCardHeader_)

ionCardHeader_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionCardHeader_ = ionCardHeader empty

instance Attr IonCardHeader_ D.Color E.Color where
  attr D.Color value = unsafeAttribute
    { key: "color", value: prop' (E.unColor value) }

instance Attr IonCardHeader_ I.Mode E.Mode where
  attr I.Mode value = unsafeAttribute
    { key: "mode", value: prop' (E.unMode value) }

instance Attr IonCardHeader_ I.Translucent Boolean where
  attr I.Translucent value = unsafeAttribute
    { key: "translucent", value: prop' (if value then "true" else "false") }
