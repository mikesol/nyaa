module Nyaa.Ionic.CardSubtitle where


import Control.Plus (empty)
import Deku.Attribute (class Attr, Attribute, prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (unsafeCustomElement)
import Deku.DOM as D
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Enums as E
import Type.Proxy (Proxy(..))

data IonCardSubtitle_
data IonCardSubtitle

ionCardSubtitle
  :: forall lock payload
   . Event (Attribute IonCardSubtitle_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionCardSubtitle = unsafeCustomElement "ion-card-subtitle"
  (Proxy :: Proxy IonCardSubtitle_)

ionCardSubtitle_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionCardSubtitle_ = ionCardSubtitle empty

instance Attr IonCardSubtitle_ D.Color E.Color where
  attr D.Color value = unsafeAttribute
    { key: "color", value: prop' (E.unColor value) }

instance Attr IonCardSubtitle_ I.Mode E.Mode where
  attr I.Mode value = unsafeAttribute
    { key: "mode", value: prop' (E.unMode value) }
