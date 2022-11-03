module Nyaa.Ionic.Content where

import Prelude

import Bolson.Core (Entity(..), fixed)
import Control.Plus (empty)
import Control.Promise (Promise)
import Data.Array (mapWithIndex)
import Deku.Attribute (class Attr, Attribute, Cb(..), cb', prop', unsafeAttribute)
import Deku.Control (elementify)
import Deku.Core (Domable(..), Domable', unsafeSetPos)
import Deku.DOM (SelfT(..), unsafeCustomElement)
import Deku.DOM as D
import Effect (Effect)
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Safe.Coerce (coerce)
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)
import Web.HTML (HTMLElement)

data IonContent_
data IonContent

ionContent
  :: forall lock payload
   . Event (Attribute IonContent_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionContent = unsafeCustomElement "ion-content" (Proxy :: Proxy IonContent_)

ionContent_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionContent_ = ionContent empty

instance Attr IonContent_ D.Class String where
  attr D.Class value = unsafeAttribute { key: "class", value: prop' value }

instance Attr IonContent_ D.Color String where
  attr D.Color value = unsafeAttribute { key: "color", value: prop' value }

instance Attr IonContent_ D.Style String where
  attr D.Style value = unsafeAttribute { key: "style", value: prop' value }

instance Attr IonContent_ I.ForceOverscroll String where
  attr I.ForceOverscroll value = unsafeAttribute { key: "force-overscroll", value: prop' value }

instance Attr IonContent_ I.Fullscren String where
  attr I.Fullscren value = unsafeAttribute { key: "fullscreen", value: prop' value }

instance Attr IonContent_ I.ScrollEvents String where
  attr I.ScrollEvents value = unsafeAttribute { key: "scroll-events", value: prop' value }

instance Attr IonContent_ I.ScrollX String where
  attr I.ScrollX value = unsafeAttribute { key: "scroll-x", value: prop' value }

instance Attr IonContent_ I.ScrollY String where
  attr I.ScrollY value = unsafeAttribute { key: "scroll-y", value: prop' value }

instance Attr IonContent_ I.OnIonScroll Cb where
  attr I.OnIonScroll value = unsafeAttribute { key: "ionScroll", value: cb' value }

instance Attr IonContent_ I.OnIonScroll (Effect Unit) where
  attr I.OnIonScroll value = unsafeAttribute
    { key: "ionScroll", value: cb' (Cb (const (value $> true))) }

instance Attr IonContent_ I.OnIonScroll (Effect Boolean) where
  attr I.OnIonScroll value = unsafeAttribute
    { key: "ionScroll", value: cb' (Cb (const value)) }

instance Attr IonContent_ I.OnIonScrollStart Cb where
  attr I.OnIonScrollStart value = unsafeAttribute { key: "ionScrollStart", value: cb' value }

instance Attr IonContent_ I.OnIonScrollStart (Effect Unit) where
  attr I.OnIonScrollStart value = unsafeAttribute
    { key: "ionScrollStart", value: cb' (Cb (const (value $> true))) }

instance Attr IonContent_ I.OnIonScrollStart (Effect Boolean) where
  attr I.OnIonScrollStart value = unsafeAttribute
    { key: "ionScrollStart", value: cb' (Cb (const value)) }

instance Attr IonContent_ I.OnIonScrollEnd Cb where
  attr I.OnIonScrollEnd value = unsafeAttribute { key: "ionScrollEnd", value: cb' value }

instance Attr IonContent_ I.OnIonScrollEnd (Effect Unit) where
  attr I.OnIonScrollEnd value = unsafeAttribute
    { key: "ionScrollEnd", value: cb' (Cb (const (value $> true))) }

instance Attr IonContent_ I.OnIonScrollEnd (Effect Boolean) where
  attr I.OnIonScrollEnd value = unsafeAttribute
    { key: "ionScrollEnd", value: cb' (Cb (const value)) }

instance Attr IonContent_ SelfT (IonContent -> Effect Unit) where
  attr SelfT value = unsafeAttribute
    { key: "@self@", value: cb' (Cb (unsafeCoerce value)) }

foreign import getScrollElement :: IonContent -> Effect (Promise HTMLElement)
foreign import scrollByPoint :: IonContent -> Number -> Number -> Number -> Effect (Promise Unit)
foreign import scrollToBottom :: IonContent -> Number -> Effect (Promise Unit)
foreign import scrollToPoint :: IonContent -> Number -> Number -> Number -> Effect (Promise Unit)
foreign import scrollToTop :: IonContent -> Number -> Effect (Promise Unit)
