module Nyaa.Ionic.Route where

import Prelude

import Control.Plus (empty)
import Control.Promise (Promise)
import Deku.Attribute (class Attr, Attribute, Cb(..), cb', prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (SelfT(..), unsafeCustomElement)
import Effect (Effect)
import FRP.Event (Event)
import Foreign (Foreign)
import Foreign.Object (Object)
import Nyaa.Ionic.Attributes as I
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)
import Untagged.Union (type (|+|), UndefinedOr)

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

instance Attr IonRoute_ I.Component String where
  attr I.Component value = unsafeAttribute { key: "component", value: prop' value }

instance Attr IonRoute_ I.Url String where
  attr I.Url value = unsafeAttribute { key: "url", value: prop' value }

instance Attr IonRoute_ I.OnIonRouteDataChanged Cb where
  attr I.OnIonRouteDataChanged value = unsafeAttribute { key: "ionRouteDataChanged", value: cb' value }

instance Attr IonRoute_ I.OnIonRouteDataChanged (Effect Unit) where
  attr I.OnIonRouteDataChanged value = unsafeAttribute
    { key: "ionRouteDataChanged", value: cb' (Cb (const (value $> true))) }

instance Attr IonRoute_ I.OnIonRouteDataChanged (Effect Boolean) where
  attr I.OnIonRouteDataChanged value = unsafeAttribute
    { key: "ionRouteDataChanged", value: cb' (Cb (const value)) }

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

type NavigationHookResult = Boolean |+|
  { redirect :: String
  }

foreign import beforeEnter :: IonRoute -> UndefinedOr (Effect (Promise NavigationHookResult)) -> Effect Unit
foreign import beforeLeave :: IonRoute -> UndefinedOr (Effect (Promise NavigationHookResult)) -> Effect Unit
foreign import componentProps :: IonRoute -> UndefinedOr (Object Foreign) -> Effect Unit
foreign import getBeforeEnter :: IonRoute -> Effect (UndefinedOr (Effect (Promise NavigationHookResult)))
foreign import getBeforeLeave :: IonRoute -> Effect (UndefinedOr (Effect (Promise NavigationHookResult)))
foreign import getComponentProps :: IonRoute -> Effect (UndefinedOr (Object Foreign))
