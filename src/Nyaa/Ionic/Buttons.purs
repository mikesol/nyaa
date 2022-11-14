module Nyaa.Ionic.Buttons where


import Control.Plus (empty)
import Deku.Attribute (class Attr, Attribute, prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (unsafeCustomElement)
import Deku.DOM as D
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Type.Proxy (Proxy(..))

data IonButtons_

ionButtons
  :: forall lock payload
   . Event (Attribute IonButtons_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionButtons = unsafeCustomElement "ion-buttons" (Proxy :: Proxy IonButtons_)

ionButtons_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionButtons_ = ionButtons empty

instance Attr IonButtons_ I.Slot String where
  attr I.Slot value = unsafeAttribute { key: "slot", value: prop' value }

instance Attr IonButtons_ D.Class String where
  attr D.Class value = unsafeAttribute { key: "class", value: prop' value }

instance Attr IonButtons_ D.Style String where
  attr D.Style value = unsafeAttribute { key: "style", value: prop' value }

instance Attr IonButtons_ I.Collapse Boolean where
  attr I.Collapse value = unsafeAttribute { key: "collapse", value: prop' (if value then "true" else "false") }

