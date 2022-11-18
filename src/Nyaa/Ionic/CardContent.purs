module Nyaa.Ionic.CardContent where

import Control.Plus (empty)
import Deku.Attribute (class Attr, Attribute, prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (unsafeCustomElement)
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Enums as E
import Type.Proxy (Proxy(..))

data IonCardContent_
data IonCardContent

ionCardContent
  :: forall lock payload
   . Event (Attribute IonCardContent_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionCardContent = unsafeCustomElement "ion-card-content"
  (Proxy :: Proxy IonCardContent_)

ionCardContent_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionCardContent_ = ionCardContent empty

instance Attr IonCardContent_ I.Mode E.Mode where
  attr I.Mode value = unsafeAttribute
    { key: "mode", value: prop' (E.unMode value) }

