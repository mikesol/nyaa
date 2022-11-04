module Nyaa.Ionic.Header
  ( IonHeader(..)
  , IonHeader_(..)
  , Mode
  , Collapse
  , collapseCondense
  , collapseFade
  , ionHeader
  , ionHeader_
  , modeIOS
  , modeMD
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

newtype Collapse = Collapse String
newtype Mode = Mode String
modeIOS :: Mode
modeIOS = Mode "ios"
modeMD :: Mode
modeMD = Mode "md"
collapseFade :: Collapse
collapseFade = Collapse "fade"
collapseCondense :: Collapse
collapseCondense = Collapse "condense" 
instance Attr IonHeader_ D.Class String where
  attr D.Class value = unsafeAttribute { key: "class", value: prop' value }

instance Attr IonHeader_ D.Style String where
  attr D.Style value = unsafeAttribute { key: "style", value: prop' value }

instance Attr IonHeader_ I.Collapse Collapse where
  attr I.Collapse (Collapse value) = unsafeAttribute { key: "collapse", value: prop' value }

instance Attr IonHeader_ I.Mode Mode where
  attr I.Mode (Mode value) = unsafeAttribute { key: "mode", value: prop' value }

instance Attr IonHeader_ I.Translucent Boolean where
  attr I.Translucent value = unsafeAttribute { key: "translucent", value: prop' (if value then "true" else "false") }
