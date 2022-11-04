module Nyaa.Ionic.Toolbar
  ( IonToolbar(..)
  , IonToolbar_(..)
  , ionToolbar
  , ionToolbar_
  )
  where


import Control.Plus (empty)
import Deku.Attribute (class Attr, Attribute, prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (unsafeCustomElement)
import Deku.DOM as D
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Enums as E
import Type.Proxy (Proxy(..))

data IonToolbar_
data IonToolbar

ionToolbar
  :: forall lock payload
   . Event (Attribute IonToolbar_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionToolbar = unsafeCustomElement "ion-toolbar" (Proxy :: Proxy IonToolbar_)

ionToolbar_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionToolbar_ = ionToolbar empty

instance Attr IonToolbar_ D.Class String where
  attr D.Class value = unsafeAttribute { key: "class", value: prop' value }

instance Attr IonToolbar_ D.Style String where
  attr D.Style value = unsafeAttribute { key: "style", value: prop' value }

instance Attr IonToolbar_ D.Color E.Color where
  attr D.Color value = unsafeAttribute { key: "color", value: prop' (E.unColor value) }

instance Attr IonToolbar_ I.Mode E.Mode where
  attr I.Mode value = unsafeAttribute { key: "mode", value: prop' (E.unMode value) }
