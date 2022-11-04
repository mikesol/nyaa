module Nyaa.Ionic.Header
  ( IonHeader(..)
  , IonHeader_(..)
  , ionHeader
  , ionHeader_
  )
  where


import Control.Plus (empty)
import Deku.Attribute (class Attr, Attribute, prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (unsafeCustomElement)
import Deku.DOM as D
import FRP.Event (Event)
import Nyaa.Ionic.Enums as E
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Enums (unCollapse, unMode)
import Type.Proxy (Proxy(..))

data IonHeader_
data IonHeader

ionHeader
  :: forall lock payload
   . Event (Attribute IonHeader_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionHeader = unsafeCustomElement "ion-header" (Proxy :: Proxy IonHeader_)

ionHeader_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionHeader_ = ionHeader empty

instance Attr IonHeader_ D.Class String where
  attr D.Class value = unsafeAttribute { key: "class", value: prop' value }

instance Attr IonHeader_ D.Style String where
  attr D.Style value = unsafeAttribute { key: "style", value: prop' value }

instance Attr IonHeader_ I.Collapse E.Collapse where
  attr I.Collapse value = unsafeAttribute { key: "collapse", value: prop' (unCollapse value) }

instance Attr IonHeader_ I.Mode E.Mode where
  attr I.Mode value = unsafeAttribute { key: "mode", value: prop' (unMode value) }

instance Attr IonHeader_ I.Translucent Boolean where
  attr I.Translucent value = unsafeAttribute { key: "translucent", value: prop' (if value then "true" else "false") }
