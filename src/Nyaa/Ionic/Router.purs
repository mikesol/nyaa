module Nyaa.Ionic.Router
  ( AnimationBuilder(..)
  , IonRouter(..)
  , IonRouter_(..)
  , back
  , ionRouter
  , ionRouter_
  , push
  , routerBack
  , routerForward
  , routerRoot
  , RouterDirection
  )
  where


import Prelude

import Bolson.Core (Entity(..), fixed)
import Control.Plus (empty)
import Data.Array (mapWithIndex)
import Data.Nullable (Nullable)
import Deku.Attribute (class Attr, Attribute, Cb(..), cb', prop', unsafeAttribute)
import Deku.Control (elementify)
import Deku.Core (Domable(..), Domable', unsafeSetPos)
import Deku.DOM (SelfT(..))
import Effect (Effect)
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Safe.Coerce (coerce)
import Unsafe.Coerce (unsafeCoerce)

data IonRouter_
data IonRouter

-- ionic doesn't really document this, so we make it an opaque blob for now
-- and folks can `unsafeCoerce` something to this if they really need it
data AnimationBuilder

ionRouter
  :: forall lock payload
   . Event (Attribute IonRouter_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionRouter attributes kids = Domable
  ( Element'
      ( elementify "ion-router" attributes
          ( (coerce :: Domable' lock payload -> Domable lock payload)
              (fixed (coerce (mapWithIndex unsafeSetPos kids)))
          )
      )
  )

ionRouter_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionRouter_ = ionRouter empty

instance Attr IonRouter_ I.Root String where
  attr I.Root value = unsafeAttribute { key: "root", value: prop' value }

instance Attr IonRouter_ I.UseHash String where
  attr I.UseHash value = unsafeAttribute { key: "use-hash", value: prop' value }

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

newtype RouterDirection = RouterDirection String

routerForward :: RouterDirection
routerForward = RouterDirection "forward"
routerBack :: RouterDirection
routerBack = RouterDirection "back"
routerRoot :: RouterDirection
routerRoot = RouterDirection "root"

foreign import back :: IonRouter -> Effect Unit
foreign import push :: IonRouter -> String -> Nullable RouterDirection -> Nullable AnimationBuilder -> Effect Unit