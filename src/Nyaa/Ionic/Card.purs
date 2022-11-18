module Nyaa.Ionic.Card where

import Prelude

import Control.Plus (empty)
import Deku.Attribute (class Attr, Attribute, Cb(..), cb', prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (unsafeCustomElement)
import Deku.DOM as D
import Effect (Effect)
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Enums as E
import Nyaa.Ionic.Unsafe (RouterAnimation)
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

data IonCard_
data IonCard

ionCard
  :: forall lock payload
   . Event (Attribute IonCard_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionCard = unsafeCustomElement "ion-card" (Proxy :: Proxy IonCard_)

ionCard_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionCard_ = ionCard empty

instance Attr IonCard_ D.Class String where
  attr D.Class value = unsafeAttribute { key: "class", value: prop' value }

instance Attr IonCard_ D.Style String where
  attr D.Style value = unsafeAttribute { key: "style", value: prop' value }

instance Attr IonCard_ I.Slot String where
  attr I.Slot value = unsafeAttribute { key: "slot", value: prop' value }

instance Attr IonCard_ I.Button Boolean where
  attr I.Button value = unsafeAttribute
    { key: "button", value: prop' (if value then "true" else "false") }

instance Attr IonCard_ D.Color E.Color where
  attr D.Color value = unsafeAttribute
    { key: "color", value: prop' (E.unColor value) }

instance Attr IonCard_ D.Disabled Boolean where
  attr D.Disabled value = unsafeAttribute
    { key: "disabled", value: prop' (if value then "true" else "false") }

instance Attr IonCard_ D.Download String where
  attr D.Download value = unsafeAttribute
    { key: "download", value: prop' value }

instance Attr IonCard_ D.Href String where
  attr D.Href value = unsafeAttribute { key: "href", value: prop' value }

instance Attr IonCard_ I.Mode E.Mode where
  attr I.Mode value = unsafeAttribute
    { key: "mode", value: prop' (E.unMode value) }

instance Attr IonCard_ D.Rel String where
  attr D.Rel value = unsafeAttribute { key: "rel", value: prop' value }

instance Attr IonCard_ I.RouterDirection E.RouterDirection where
  attr I.RouterDirection value = unsafeAttribute
    { key: "router-direction", value: prop' (E.unRouterDirection value) }

instance Attr IonCard_ D.Target String where
  attr D.Target value = unsafeAttribute { key: "target", value: prop' value }

instance Attr IonCard_ D.Xtype E.ItemType where
  attr D.Xtype value = unsafeAttribute
    { key: "type", value: prop' (E.unItemType value) }

instance Attr IonCard_ D.SelfT (IonCard -> Effect Unit) where
  attr D.SelfT value = unsafeAttribute
    { key: "@self@", value: cb' (Cb (unsafeCoerce value)) }

foreign import routerAnimation :: IonCard -> RouterAnimation -> Effect Unit
foreign import getRouterAnimation :: IonCard -> Effect RouterAnimation