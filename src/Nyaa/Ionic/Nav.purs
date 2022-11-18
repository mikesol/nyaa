module Nyaa.Ionic.Nav
  ( IonNav(..)
  , IonNav_(..)
  , ionNav
  , ionNav_
  ) where

-- todo: incomplete, add methods

import Prelude

import Control.Plus (empty)
import Deku.Attribute (class Attr, Attribute, Cb(..), cb', prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (SelfT(..), unsafeCustomElement)
import Effect (Effect)
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

data IonNav_
data IonNav

ionNav
  :: forall lock payload
   . Event (Attribute IonNav_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionNav = unsafeCustomElement "ion-nav" (Proxy :: Proxy IonNav_)

ionNav_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionNav_ = ionNav empty

instance Attr IonNav_ I.Animated Boolean where
  attr I.Animated value = unsafeAttribute
    { key: "animated", value: prop' (if value then "true" else "false") }

-- todo add animation
-- todo add root
-- todo add rootParams

instance Attr IonNav_ I.SwipeGesture Boolean where
  attr I.SwipeGesture value = unsafeAttribute
    { key: "swipe-gesture", value: prop' (if value then "true" else "false") }

instance Attr IonNav_ I.OnIonNavDidChange (Effect Unit) where
  attr I.OnIonNavDidChange value = unsafeAttribute
    { key: "ionNavDidChange", value: cb' (Cb (const (value $> true))) }

instance Attr IonNav_ I.OnIonNavDidChange (Effect Boolean) where
  attr I.OnIonNavDidChange value = unsafeAttribute
    { key: "ionNavDidChange", value: cb' (Cb (const value)) }

instance Attr IonNav_ I.OnIonNavWillChange Cb where
  attr I.OnIonNavWillChange value = unsafeAttribute
    { key: "ionNavWillChange", value: cb' value }

instance Attr IonNav_ I.OnIonNavWillChange (Effect Unit) where
  attr I.OnIonNavWillChange value = unsafeAttribute
    { key: "ionNavWillChange", value: cb' (Cb (const (value $> true))) }

instance Attr IonNav_ I.OnIonNavWillChange (Effect Boolean) where
  attr I.OnIonNavWillChange value = unsafeAttribute
    { key: "ionNavWillChange", value: cb' (Cb (const value)) }

instance Attr IonNav_ SelfT (IonNav -> Effect Unit) where
  attr SelfT value = unsafeAttribute
    { key: "@self@", value: cb' (Cb (unsafeCoerce value)) }

