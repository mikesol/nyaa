module Nyaa.Ionic.Route
  ( AnimationBuilder(..)
  , IonRoute(..)
  , IonRoute_(..)
  , back
  , ionRoute
  , ionRoute_
  , push
  , RouteDirection
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
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

data IonRoute_
data IonRoute

-- ionic doesn't really document this, so we make it an opaque blob for now
-- and folks can `unsafeCoerce` something to this if they really need it
data AnimationBuilder

ionRoute
  :: forall lock payload
   . Event (Attribute IonRoute_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionRoute = unsafeCustomElement "ion-route" (Proxy :: Proxy IonRoute_)
ionRoute_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionRoute_ = ionRoute empty

instance Attr IonRoute_ I.Root String where
  attr I.Root value = unsafeAttribute { key: "root", value: prop' value }

instance Attr IonRoute_ I.UseHash String where
  attr I.UseHash value = unsafeAttribute { key: "use-hash", value: prop' value }

instance Attr IonRoute_ I.OnIonRouteDidChange Cb where
  attr I.OnIonRouteDidChange value = unsafeAttribute { key: "ionRouteDidChange", value: cb' value }

instance Attr IonRoute_ I.OnIonRouteDidChange (Effect Unit) where
  attr I.OnIonRouteDidChange value = unsafeAttribute
    { key: "ionRouteDidChange", value: cb' (Cb (const (value $> true))) }

instance Attr IonRoute_ I.OnIonRouteDidChange (Effect Boolean) where
  attr I.OnIonRouteDidChange value = unsafeAttribute
    { key: "ionRouteDidChange", value: cb' (Cb (const value)) }
  
instance Attr IonRoute_ I.OnIonRouteWillChange Cb where
  attr I.OnIonRouteWillChange value = unsafeAttribute { key: "ionRouteWillChange", value: cb' value }

instance Attr IonRoute_ I.OnIonRouteWillChange (Effect Unit) where
  attr I.OnIonRouteWillChange value = unsafeAttribute
    { key: "ionRouteWillChange", value: cb' (Cb (const (value $> true))) }

instance Attr IonRoute_ I.OnIonRouteWillChange (Effect Boolean) where
  attr I.OnIonRouteWillChange value = unsafeAttribute
    { key: "ionRouteWillChange", value: cb' (Cb (const value)) }

instance Attr IonRoute_ SelfT (IonRoute -> Effect Unit) where
  attr SelfT value = unsafeAttribute
    { key: "@self@", value: cb' (Cb (unsafeCoerce value)) }

newtype RouteDirection = RouteDirection String

foreign import back :: IonRoute -> Effect Unit
foreign import push :: IonRoute -> String -> Nullable RouteDirection -> Nullable AnimationBuilder -> Effect Unit