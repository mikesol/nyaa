module Nyaa.Ionic.Title
  ( IonTitle(..)
  , IonTitle_(..)
  , ionTitle
  , ionTitle_
  ) where

import Control.Plus (empty)
import Deku.Attribute (class Attr, Attribute, prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (unsafeCustomElement)
import Deku.DOM as D
import FRP.Event (Event)
import Nyaa.Ionic.Enums as E
import Type.Proxy (Proxy(..))

data IonTitle_
data IonTitle

ionTitle
  :: forall lock payload
   . Event (Attribute IonTitle_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionTitle = unsafeCustomElement "ion-title" (Proxy :: Proxy IonTitle_)

ionTitle_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionTitle_ = ionTitle empty

instance Attr IonTitle_ D.Class String where
  attr D.Class value = unsafeAttribute { key: "class", value: prop' value }

instance Attr IonTitle_ D.Style String where
  attr D.Style value = unsafeAttribute { key: "style", value: prop' value }

instance Attr IonTitle_ D.Color E.Color where
  attr D.Color value = unsafeAttribute
    { key: "color", value: prop' (E.unColor value) }

instance Attr IonTitle_ D.Size E.TitleSize where
  attr D.Size value = unsafeAttribute
    { key: "size", value: prop' (E.unTitleSize value) }
