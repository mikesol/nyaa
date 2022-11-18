module Nyaa.Ionic.Modal where

import Prelude

import Control.Plus (empty)
import Control.Promise (Promise)
import Data.Nullable (Nullable)
import Deku.Attribute (class Attr, Attribute, Cb(..), cb', prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (SelfT(..), unsafeCustomElement)
import Effect (Effect)
import FRP.Event (Event)
import Foreign (Foreign)
import Foreign.Object (Object)
import Nyaa.Ionic.Attributes as D
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Enums as E
import Nyaa.Ionic.Unsafe (EnterAnimation, LeaveAnimation)
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)
import Untagged.Union (type (|+|), UndefinedOr)
import Web.DOM as Web.DOM

data IonModal_
data IonModal

ionModal
  :: forall lock payload
   . Event (Attribute IonModal_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionModal = unsafeCustomElement "ion-modal" (Proxy :: Proxy IonModal_)

ionModal_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionModal_ = ionModal empty

instance Attr IonModal_ D.Animated Boolean where
  attr D.Animated value = unsafeAttribute
    { key: "animated", value: prop' (if value then "true" else "false") }

instance Attr IonModal_ I.BackdropBreakpoint Number where
  attr I.BackdropBreakpoint value = unsafeAttribute
    { key: "backdrop-breakpoint", value: prop' (show value) }

instance Attr IonModal_ I.BackdropDismiss Boolean where
  attr I.BackdropDismiss value = unsafeAttribute
    { key: "backdrop-dismiss"
    , value: prop' (if value then "true" else "false")
    }

instance Attr IonModal_ I.CanDismiss Boolean where
  attr I.CanDismiss value = unsafeAttribute
    { key: "can-dismiss", value: prop' (if value then "true" else "false") }

instance Attr IonModal_ I.Handle Boolean where
  attr I.Handle value = unsafeAttribute
    { key: "handle", value: prop' (if value then "true" else "false") }

instance Attr IonModal_ I.HandleBehavior E.HandleBehavior where
  attr I.HandleBehavior value = unsafeAttribute
    { key: "handle-behavior", value: prop' (E.unHandleBehavior value) }

instance Attr IonModal_ I.InitialBreakpoint Number where
  attr I.InitialBreakpoint value = unsafeAttribute
    { key: "initial-breakpoint", value: prop' (show value) }

instance Attr IonModal_ I.IsOpen Boolean where
  attr I.IsOpen value = unsafeAttribute
    { key: "is-open", value: prop' (if value then "true" else "false") }

instance Attr IonModal_ I.KeepContentsMounted Boolean where
  attr I.KeepContentsMounted value = unsafeAttribute
    { key: "keep-contents-mounted"
    , value: prop' (if value then "true" else "false")
    }

instance Attr IonModal_ I.KeyboardClose Boolean where
  attr I.KeyboardClose value = unsafeAttribute
    { key: "keyboard-close", value: prop' (if value then "true" else "false") }

instance Attr IonModal_ I.Mode E.Mode where
  attr I.Mode value = unsafeAttribute
    { key: "mode", value: prop' (E.unMode value) }

instance Attr IonModal_ I.ShowBackdrop Boolean where
  attr I.ShowBackdrop value = unsafeAttribute
    { key: "show-backdrop", value: prop' (if value then "true" else "false") }

instance Attr IonModal_ I.Trigger String where
  attr I.Trigger value = unsafeAttribute { key: "trigger", value: prop' value }

--
instance Attr IonModal_ I.OnIonBreakpointDidChange Cb where
  attr I.OnIonBreakpointDidChange value = unsafeAttribute
    { key: "ionBreakpointDidChange", value: cb' value }

instance Attr IonModal_ I.OnIonBreakpointDidChange (Effect Unit) where
  attr I.OnIonBreakpointDidChange value = unsafeAttribute
    { key: "ionBreakpointDidChange", value: cb' (Cb (const (value $> true))) }

instance Attr IonModal_ I.OnIonBreakpointDidChange (Effect Boolean) where
  attr I.OnIonBreakpointDidChange value = unsafeAttribute
    { key: "ionBreakpointDidChange", value: cb' (Cb (const value)) }

instance Attr IonModal_ I.OnIonModalDidDismiss Cb where
  attr I.OnIonModalDidDismiss value = unsafeAttribute
    { key: "ionModalDidDismiss", value: cb' value }

instance Attr IonModal_ I.OnIonModalDidDismiss (Effect Unit) where
  attr I.OnIonModalDidDismiss value = unsafeAttribute
    { key: "ionModalDidDismiss", value: cb' (Cb (const (value $> true))) }

instance Attr IonModal_ I.OnIonModalDidDismiss (Effect Boolean) where
  attr I.OnIonModalDidDismiss value = unsafeAttribute
    { key: "ionModalDidDismiss", value: cb' (Cb (const value)) }

instance Attr IonModal_ I.OnIonModalDidPresent Cb where
  attr I.OnIonModalDidPresent value = unsafeAttribute
    { key: "ionModalDidPresent", value: cb' value }

instance Attr IonModal_ I.OnIonModalDidPresent (Effect Unit) where
  attr I.OnIonModalDidPresent value = unsafeAttribute
    { key: "ionModalDidPresent", value: cb' (Cb (const (value $> true))) }

instance Attr IonModal_ I.OnIonModalDidPresent (Effect Boolean) where
  attr I.OnIonModalDidPresent value = unsafeAttribute
    { key: "ionModalDidPresent", value: cb' (Cb (const value)) }

instance Attr IonModal_ I.OnIonModalWillDismiss Cb where
  attr I.OnIonModalWillDismiss value = unsafeAttribute
    { key: "ionModalWillDismiss", value: cb' value }

instance Attr IonModal_ I.OnIonModalWillDismiss (Effect Unit) where
  attr I.OnIonModalWillDismiss value = unsafeAttribute
    { key: "ionModalWillDismiss", value: cb' (Cb (const (value $> true))) }

instance Attr IonModal_ I.OnIonModalWillDismiss (Effect Boolean) where
  attr I.OnIonModalWillDismiss value = unsafeAttribute
    { key: "ionModalWillDismiss", value: cb' (Cb (const value)) }

instance Attr IonModal_ I.OnIonModalWillPresent Cb where
  attr I.OnIonModalWillPresent value = unsafeAttribute
    { key: "ionModalWillPresent", value: cb' value }

instance Attr IonModal_ I.OnIonModalWillPresent (Effect Unit) where
  attr I.OnIonModalWillPresent value = unsafeAttribute
    { key: "ionModalWillPresent", value: cb' (Cb (const (value $> true))) }

instance Attr IonModal_ I.OnIonModalWillPresent (Effect Boolean) where
  attr I.OnIonModalWillPresent value = unsafeAttribute
    { key: "ionModalWillPresent", value: cb' (Cb (const value)) }

--

instance Attr IonModal_ SelfT (IonModal -> Effect Unit) where
  attr SelfT value = unsafeAttribute
    { key: "@self@", value: cb' (Cb (unsafeCoerce value)) }

foreign import breakpoints :: IonModal -> Array Number -> Effect Unit
foreign import getBreakpoints :: IonModal -> Effect (Nullable (Array Number))
foreign import enterAnimation :: IonModal -> EnterAnimation -> Effect Unit
foreign import getEnterAnimation :: IonModal -> Effect EnterAnimation
foreign import htmlAttributes :: IonModal -> Object String -> Effect Unit
foreign import getHtmlAttributes :: IonModal -> Effect (Object String)
foreign import leaveAnimation :: IonModal -> LeaveAnimation -> Effect Unit
foreign import getLeaveAnimation :: IonModal -> Effect LeaveAnimation
foreign import presentingElement :: IonModal -> Web.DOM.Element -> Effect Unit
foreign import getPresentingElement :: IonModal -> Effect (Web.DOM.Element)
foreign import dismiss
  :: IonModal -> Foreign -> String -> Effect (Promise Boolean)

foreign import getCurrentBreakpoint
  :: IonModal -> Effect (Promise (Nullable Number))

foreign import onDidDismiss :: IonModal -> Effect (Promise Unit)
foreign import onWillDismiss :: IonModal -> Effect (Promise Unit)
foreign import present :: IonModal -> Effect (Promise Unit)
foreign import setCurrentBreakpoint
  :: IonModal -> Number -> Effect (Promise Unit)
