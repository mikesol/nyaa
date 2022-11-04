module Nyaa.Ionic.List
  ( IonList(..)
  , IonList_(..)
  , ionList
  , ionList_
  ) where

import Prelude

import Control.Plus (empty)
import Control.Promise (Promise)
import Deku.Attribute (class Attr, Attribute, Cb(..), cb', prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (SelfT(..), unsafeCustomElement)
import Deku.DOM as D
import Effect (Effect)
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Enums as E
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

data IonList_
data IonList

ionList
  :: forall lock payload
   . Event (Attribute IonList_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionList = unsafeCustomElement "ion-list" (Proxy :: Proxy IonList_)

ionList_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionList_ = ionList empty

instance Attr IonList_ D.Class String where
  attr D.Class value = unsafeAttribute { key: "class", value: prop' value }

instance Attr IonList_ D.Style String where
  attr D.Style value = unsafeAttribute { key: "style", value: prop' value }

instance Attr IonList_ I.Inset Boolean where
  attr I.Inset value = unsafeAttribute { key: "color", value: prop' (if value then "true" else "false") }

instance Attr IonList_ I.Lines E.Lines where
  attr I.Lines value = unsafeAttribute { key: "color", value: prop' (E.unLines value) }

instance Attr IonList_ I.Mode E.Mode where
  attr I.Mode value = unsafeAttribute { key: "mode", value: prop' (E.unMode value) }

instance Attr IonList_ SelfT (IonList -> Effect Unit) where
  attr SelfT value = unsafeAttribute
    { key: "@self@", value: cb' (Cb (unsafeCoerce value)) }

foreign import closeSlidingItems :: IonList -> Effect (Promise Boolean)