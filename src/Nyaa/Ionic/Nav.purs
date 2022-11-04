module Nyaa.Ionic.Nav
  ( AnimationBuilder(..)
  , IonNav(..)
  , IonNav_(..)
  , ionNav
  , ionNav_
  )
  where

-- todo: incomplete, add methods
import Prelude

import Control.Plus (empty)
import Deku.Attribute (class Attr, Attribute, Cb(..), cb', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (SelfT(..), unsafeCustomElement)
import Effect (Effect)
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

data IonNav_
data IonNav

-- ionic doesn't really document this, so we make it an opaque blob for now
-- and folks can `unsafeCoerce` something to this if they really need it
data AnimationBuilder

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


instance Attr IonNav_ I.OnIonNavDidChange (Effect Unit) where
  attr I.OnIonNavDidChange value = unsafeAttribute
    { key: "ionNavDidChange", value: cb' (Cb (const (value $> true))) }

instance Attr IonNav_ I.OnIonNavDidChange (Effect Boolean) where
  attr I.OnIonNavDidChange value = unsafeAttribute
    { key: "ionNavDidChange", value: cb' (Cb (const value)) }
  
instance Attr IonNav_ I.OnIonNavWillChange Cb where
  attr I.OnIonNavWillChange value = unsafeAttribute { key: "ionNavWillChange", value: cb' value }

instance Attr IonNav_ I.OnIonNavWillChange (Effect Unit) where
  attr I.OnIonNavWillChange value = unsafeAttribute
    { key: "ionNavWillChange", value: cb' (Cb (const (value $> true))) }

instance Attr IonNav_ I.OnIonNavWillChange (Effect Boolean) where
  attr I.OnIonNavWillChange value = unsafeAttribute
    { key: "ionNavWillChange", value: cb' (Cb (const value)) }

instance Attr IonNav_ SelfT (IonNav -> Effect Unit) where
  attr SelfT value = unsafeAttribute
    { key: "@self@", value: cb' (Cb (unsafeCoerce value)) }


