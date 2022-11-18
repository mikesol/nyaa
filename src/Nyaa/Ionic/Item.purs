module Nyaa.Ionic.Item
  ( IonItem(..)
  , IonItem_(..)
  , ionItem
  , ionItem_
  ) where

import Prelude

import Control.Plus (empty)
import Data.Function.Uncurried (Fn2)
import Deku.Attribute (class Attr, Attribute, Cb(..), cb', prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (SelfT(..), unsafeCustomElement)
import Deku.DOM as D
import Effect (Effect)
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Enums as E
import Nyaa.Ionic.Unsafe (RouterAnimation)
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

data IonItem_
data IonItem

ionItem
  :: forall lock payload
   . Event (Attribute IonItem_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionItem = unsafeCustomElement "ion-item" (Proxy :: Proxy IonItem_)

ionItem_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionItem_ = ionItem empty

instance Attr IonItem_ D.Class String where
  attr D.Class value = unsafeAttribute { key: "class", value: prop' value }

instance Attr IonItem_ D.Style String where
  attr D.Style value = unsafeAttribute { key: "style", value: prop' value }

instance Attr IonItem_ I.Button Boolean where
  attr I.Button value = unsafeAttribute
    { key: "button", value: prop' (if value then "true" else "false") }

instance Attr IonItem_ D.Color E.Color where
  attr D.Color value = unsafeAttribute
    { key: "color", value: prop' (E.unColor value) }

instance Attr IonItem_ I.Counter Boolean where
  attr I.Counter value = unsafeAttribute
    { key: "counter", value: prop' (if value then "true" else "false") }

instance Attr IonItem_ I.Detail Boolean where
  attr I.Detail value = unsafeAttribute
    { key: "detail", value: prop' (if value then "true" else "false") }

instance Attr IonItem_ I.DetailIcon String where
  attr I.DetailIcon value = unsafeAttribute
    { key: "detail-icon", value: prop' value }

instance Attr IonItem_ D.Disabled Boolean where
  attr D.Disabled value = unsafeAttribute
    { key: "disabled", value: prop' (if value then "true" else "false") }

instance Attr IonItem_ D.Download String where
  attr D.Download value = unsafeAttribute
    { key: "download", value: prop' value }

instance Attr IonItem_ I.Fill E.Fill where
  attr I.Fill value = unsafeAttribute
    { key: "fill", value: prop' (E.unFill value) }

instance Attr IonItem_ D.Href String where
  attr D.Href value = unsafeAttribute { key: "href", value: prop' value }

instance Attr IonItem_ I.Lines E.Lines where
  attr I.Lines value = unsafeAttribute
    { key: "lines", value: prop' (E.unLines value) }

instance Attr IonItem_ I.Mode E.Mode where
  attr I.Mode value = unsafeAttribute
    { key: "mode", value: prop' (E.unMode value) }

instance Attr IonItem_ I.Rel String where
  attr I.Rel value = unsafeAttribute { key: "rel", value: prop' value }

instance Attr IonItem_ I.RouterDirection E.RouterDirection where
  attr I.RouterDirection value = unsafeAttribute
    { key: "router-direction", value: prop' (E.unRouterDirection value) }

instance Attr IonItem_ I.Shape E.ItemShape where
  attr I.Shape value = unsafeAttribute
    { key: "shape", value: prop' (E.unItemShape value) }

instance Attr IonItem_ D.Target String where
  attr D.Target value = unsafeAttribute { key: "target", value: prop' value }

instance Attr IonItem_ D.Xtype E.ItemType where
  attr D.Xtype value = unsafeAttribute
    { key: "type", value: prop' (E.unItemType value) }

instance Attr IonItem_ SelfT (IonItem -> Effect Unit) where
  attr SelfT value = unsafeAttribute
    { key: "@self@", value: cb' (Cb (unsafeCoerce value)) }

type CounterFormatter = Fn2 Number Number String

foreign import counterFormatter :: IonItem -> CounterFormatter -> Effect Unit
foreign import getCounterFormatter :: IonItem -> Effect CounterFormatter
foreign import routerAnimation :: IonItem -> RouterAnimation -> Effect Unit
foreign import getRouterAnimation :: IonItem -> Effect RouterAnimation