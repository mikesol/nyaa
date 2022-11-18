module Nyaa.Ionic.BackButton
  ( IonBackButton(..)
  , IonBackButton_(..)
  , ionBackButton
  , ionBackButton_
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

data IonBackButton_
data IonBackButton

ionBackButton
  :: forall lock payload
   . Event (Attribute IonBackButton_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionBackButton = unsafeCustomElement "ion-back-button"
  (Proxy :: Proxy IonBackButton_)

ionBackButton_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionBackButton_ = ionBackButton empty

instance Attr IonBackButton_ D.Class String where
  attr D.Class value = unsafeAttribute { key: "class", value: prop' value }

instance Attr IonBackButton_ D.Style String where
  attr D.Style value = unsafeAttribute { key: "style", value: prop' value }

instance Attr IonBackButton_ I.Slot String where
  attr I.Slot value = unsafeAttribute { key: "slot", value: prop' value }

instance Attr IonBackButton_ D.Color E.Color where
  attr D.Color value = unsafeAttribute
    { key: "color", value: prop' (E.unColor value) }

instance Attr IonBackButton_ I.DefaultHref String where
  attr I.DefaultHref value = unsafeAttribute
    { key: "default-href", value: prop' value }

instance Attr IonBackButton_ D.Disabled Boolean where
  attr D.Disabled value = unsafeAttribute
    { key: "disabled", value: prop' (if value then "true" else "false") }

instance Attr IonBackButton_ I.Icon String where
  attr I.Icon value = unsafeAttribute { key: "icon", value: prop' value }

instance Attr IonBackButton_ I.Mode E.Mode where
  attr I.Mode value = unsafeAttribute
    { key: "mode", value: prop' (E.unMode value) }

instance Attr IonBackButton_ I.Text String where
  attr I.Text value = unsafeAttribute { key: "text", value: prop' value }

instance Attr IonBackButton_ D.Xtype E.ItemType where
  attr D.Xtype value = unsafeAttribute
    { key: "type", value: prop' (E.unItemType value) }

instance Attr IonBackButton_ SelfT (IonBackButton -> Effect Unit) where
  attr SelfT value = unsafeAttribute
    { key: "@self@", value: cb' (Cb (unsafeCoerce value)) }

type CounterFormatter = Fn2 Number Number String

foreign import routerAnimation
  :: IonBackButton -> RouterAnimation -> Effect Unit

foreign import getRouterAnimation :: IonBackButton -> Effect RouterAnimation