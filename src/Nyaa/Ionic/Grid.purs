module Nyaa.Ionic.Grid
  ( IonGrid(..)
  , IonGrid_(..)
  , ionGrid
  , ionGrid_
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

data IonGrid_
data IonGrid

ionGrid
  :: forall lock payload
   . Event (Attribute IonGrid_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionGrid = unsafeCustomElement "ion-grid" (Proxy :: Proxy IonGrid_)

ionGrid_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionGrid_ = ionGrid empty

instance Attr IonGrid_ D.Class String where
  attr D.Class value = unsafeAttribute { key: "class", value: prop' value }

instance Attr IonGrid_ D.Style String where
  attr D.Style value = unsafeAttribute { key: "style", value: prop' value }

instance Attr IonGrid_ I.Fixed Boolean where
  attr I.Fixed value = unsafeAttribute { key: "fixed", value: prop' (if value then "true" else "false") }

