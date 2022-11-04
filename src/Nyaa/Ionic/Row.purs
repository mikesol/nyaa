module Nyaa.Ionic.Row
  ( IonRow(..)
  , IonRow_(..)
  , ionRow
  , ionRow_
  ) where

import Control.Plus (empty)
import Deku.Attribute (class Attr, Attribute, prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (unsafeCustomElement)
import Deku.DOM as D
import FRP.Event (Event)
import Type.Proxy (Proxy(..))

data IonRow_
data IonRow

ionRow
  :: forall lock payload
   . Event (Attribute IonRow_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionRow = unsafeCustomElement "ion-row" (Proxy :: Proxy IonRow_)

ionRow_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionRow_ = ionRow empty

instance Attr IonRow_ D.Class String where
  attr D.Class value = unsafeAttribute { key: "class", value: prop' value }

instance Attr IonRow_ D.Style String where
  attr D.Style value = unsafeAttribute { key: "style", value: prop' value }
