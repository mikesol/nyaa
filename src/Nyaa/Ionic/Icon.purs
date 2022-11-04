module Nyaa.Ionic.Icon
  ( IonIcon(..)
  , IonIcon_(..)
  , ionIcon
  , ionIcon_
  )
  where


import Control.Plus (empty)
import Deku.Attribute (class Attr, Attribute, prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (unsafeCustomElement)
import Deku.DOM as D
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Type.Proxy (Proxy(..))

data IonIcon_
data IonIcon

ionIcon
  :: forall lock payload
   . Event (Attribute IonIcon_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionIcon = unsafeCustomElement "ion-icon" (Proxy :: Proxy IonIcon_)

ionIcon_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionIcon_ = ionIcon empty

instance Attr IonIcon_ D.Class String where
  attr D.Class value = unsafeAttribute { key: "class", value: prop' value }

instance Attr IonIcon_ D.Style String where
  attr D.Style value = unsafeAttribute { key: "style", value: prop' value }

instance Attr IonIcon_ D.Size String where
  attr D.Size value = unsafeAttribute { key: "size", value: prop' value }

instance Attr IonIcon_ D.Name String where
  attr D.Name value = unsafeAttribute { key: "name", value: prop' value }

instance Attr IonIcon_ I.Slot String where
  attr I.Slot value = unsafeAttribute { key: "slot", value: prop' value }
