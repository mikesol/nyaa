module Nyaa.Ionic.CardTitle where

import Control.Plus (empty)
import Deku.Attribute (class Attr, Attribute, prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (unsafeCustomElement)
import Deku.DOM as D
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Enums as E
import Type.Proxy (Proxy(..))

data IonCardTitle_
data IonCardTitle

ionCardTitle
  :: forall lock payload
   . Event (Attribute IonCardTitle_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionCardTitle = unsafeCustomElement "ion-card-title"
  (Proxy :: Proxy IonCardTitle_)

ionCardTitle_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionCardTitle_ = ionCardTitle empty

instance Attr IonCardTitle_ D.Color E.Color where
  attr D.Color value = unsafeAttribute
    { key: "color", value: prop' (E.unColor value) }

instance Attr IonCardTitle_ I.Mode E.Mode where
  attr I.Mode value = unsafeAttribute
    { key: "mode", value: prop' (E.unMode value) }
