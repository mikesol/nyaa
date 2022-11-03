module Nyaa.Ionic.RouterLink where

import Prelude

import Control.Plus (empty)
import Deku.Attribute (class Attr, Attribute, Cb(..), cb', prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (SelfT(..), unsafeCustomElement)
import Deku.DOM as D
import Effect (Effect)
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Router (RouterDirection, unRouterDirection)
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)
import Untagged.Union (UndefinedOr)

data IonRouterLink_
data IonRouterLink

-- a blob, use `unsafeCoerce` to make one
data RouterAnimation

-- ionic doesn't really document this, so we make it an opaque blob for now
-- and folks can `unsafeCoerce` something to this if they really need it
data AnimationBuilder

ionRouterLink
  :: forall lock payload
   . Event (Attribute IonRouterLink_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionRouterLink = unsafeCustomElement "ion-router-link" (Proxy :: Proxy IonRouterLink_)

ionRouterLink_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionRouterLink_ = ionRouterLink empty

instance Attr IonRouterLink_ D.Color String where
  attr D.Color value = unsafeAttribute { key: "color", value: prop' value }

instance Attr IonRouterLink_ D.Href String where
  attr D.Href value = unsafeAttribute { key: "href", value: prop' value }

instance Attr IonRouterLink_ I.Rel String where
  attr I.Rel value = unsafeAttribute { key: "rel", value: prop' value }

instance Attr IonRouterLink_ I.RouterDirection RouterDirection where
  attr I.RouterDirection value = unsafeAttribute { key: "router-direction", value: prop' (unRouterDirection value) }

instance Attr IonRouterLink_ D.Target RouterDirection where
  attr D.Target value = unsafeAttribute { key: "target", value: prop' (unRouterDirection value) }

instance Attr IonRouterLink_ SelfT (IonRouterLink -> Effect Unit) where
  attr SelfT value = unsafeAttribute
    { key: "@self@", value: cb' (Cb (unsafeCoerce value)) }

foreign import routerAnimation :: IonRouterLink -> UndefinedOr RouterAnimation -> Effect Unit
foreign import getRouterAnimation :: IonRouterLink -> Effect (UndefinedOr RouterAnimation)