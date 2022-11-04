module Nyaa.Ionic.Router
  ( IonRouter(..)
  , IonRouter_(..)
  , back
  , ionRouter
  , ionRouter_
  , push
  )
  where


import Prelude

import Control.Plus (empty)
import Data.Nullable (Nullable)
import Deku.Attribute (class Attr, Attribute, Cb(..), cb', prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (SelfT(..), unsafeCustomElement)
import Effect (Effect)
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Enums as E
import Nyaa.Ionic.Unsafe as U
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

data IonRouter_
data IonRouter

ionRouter
  :: forall lock payload
   . Event (Attribute IonRouter_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionRouter = unsafeCustomElement "ion-router" (Proxy :: Proxy IonRouter_)

ionRouter_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionRouter_ = ionRouter empty

instance Attr IonRouter_ I.Root String where
  attr I.Root value = unsafeAttribute { key: "root", value: prop' value }

instance Attr IonRouter_ I.UseHash Boolean where
  attr I.UseHash value = unsafeAttribute { key: "use-hash", value: prop' (if value then "true" else "false") }

instance Attr IonRouter_ I.OnIonRouteDidChange Cb where
  attr I.OnIonRouteDidChange value = unsafeAttribute { key: "ionRouteDidChange", value: cb' value }

instance Attr IonRouter_ I.OnIonRouteDidChange (Effect Unit) where
  attr I.OnIonRouteDidChange value = unsafeAttribute
    { key: "ionRouteDidChange", value: cb' (Cb (const (value $> true))) }

instance Attr IonRouter_ I.OnIonRouteDidChange (Effect Boolean) where
  attr I.OnIonRouteDidChange value = unsafeAttribute
    { key: "ionRouteDidChange", value: cb' (Cb (const value)) }
  
instance Attr IonRouter_ I.OnIonRouteWillChange Cb where
  attr I.OnIonRouteWillChange value = unsafeAttribute { key: "ionRouteWillChange", value: cb' value }

instance Attr IonRouter_ I.OnIonRouteWillChange (Effect Unit) where
  attr I.OnIonRouteWillChange value = unsafeAttribute
    { key: "ionRouteWillChange", value: cb' (Cb (const (value $> true))) }

instance Attr IonRouter_ I.OnIonRouteWillChange (Effect Boolean) where
  attr I.OnIonRouteWillChange value = unsafeAttribute
    { key: "ionRouteWillChange", value: cb' (Cb (const value)) }

instance Attr IonRouter_ SelfT (IonRouter -> Effect Unit) where
  attr SelfT value = unsafeAttribute
    { key: "@self@", value: cb' (Cb (unsafeCoerce value)) }


foreign import back :: IonRouter -> Effect Unit
foreign import push :: IonRouter -> String -> Nullable E.RouterDirection -> Nullable U.AnimationBuilder -> Effect Unit