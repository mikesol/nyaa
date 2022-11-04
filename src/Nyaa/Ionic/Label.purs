module Nyaa.Ionic.Label
  ( IonLabel(..)
  , IonLabel_(..)
  , ionLabel
  , ionLabel_
  )
  where


import Control.Plus (empty)
import Deku.Attribute (class Attr, Attribute, prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (unsafeCustomElement)
import Deku.DOM as D
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Enums (unMode)
import Nyaa.Ionic.Enums as E
import Type.Proxy (Proxy(..))

data IonLabel_
data IonLabel

ionLabel
  :: forall lock payload
   . Event (Attribute IonLabel_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionLabel = unsafeCustomElement "ion-label" (Proxy :: Proxy IonLabel_)

ionLabel_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionLabel_ = ionLabel empty

instance Attr IonLabel_ D.Class String where
  attr D.Class value = unsafeAttribute { key: "class", value: prop' value }

instance Attr IonLabel_ D.Style String where
  attr D.Style value = unsafeAttribute { key: "style", value: prop' value }

instance Attr IonLabel_ D.Color E.Color where
  attr D.Color value = unsafeAttribute { key: "color", value: prop' (E.unColor value) }

instance Attr IonLabel_ I.Mode E.Mode where
  attr I.Mode value = unsafeAttribute { key: "mode", value: prop' (unMode value) }

instance Attr IonLabel_ I.Position E.LabelPosition where
  attr I.Position value = unsafeAttribute { key: "position", value: prop' (E.unLabelPosition value) }
