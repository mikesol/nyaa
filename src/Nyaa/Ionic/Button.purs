module Nyaa.Ionic.Button where

import Prelude

import Control.Plus (empty)
import Data.Foldable (oneOf)
import Deku.Attribute (class Attr, Attribute, Cb(..), cb', prop', unsafeAttribute)
import Deku.Control (text_)
import Deku.Core (Domable)
import Deku.DOM (unsafeCustomElement)
import Deku.DOM as D
import Deku.Listeners (click_)
import Effect (Effect)
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Type.Proxy (Proxy(..))

data IonButton_

ionButton
  :: forall lock payload
   . Event (Attribute IonButton_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionButton = unsafeCustomElement "ion-button" (Proxy :: Proxy IonButton_)


ionButton_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionButton_ = ionButton empty

instance Attr IonButton_ D.Class String where
  attr D.Class value = unsafeAttribute { key: "class", value: prop' value }

instance Attr IonButton_ D.Style String where
  attr D.Style value = unsafeAttribute { key: "style", value: prop' value }

instance Attr IonButton_ I.Slot String where
  attr I.Slot value = unsafeAttribute { key: "slot", value: prop' value }

instance Attr IonButton_ I.OnIonBlur Cb where
  attr I.OnIonBlur value = unsafeAttribute { key: "ionBlur", value: cb' value }

instance Attr IonButton_ I.OnIonBlur (Effect Unit) where
  attr I.OnIonBlur value = unsafeAttribute
    { key: "ionBlur", value: cb' (Cb (const (value $> true))) }

instance Attr IonButton_ I.OnIonBlur (Effect Boolean) where
  attr I.OnIonBlur value = unsafeAttribute
    { key: "ionBlur", value: cb' (Cb (const value)) }

instance Attr IonButton_ I.OnIonFocus Cb where
  attr I.OnIonFocus value = unsafeAttribute { key: "ionFocus", value: cb' value }

instance Attr IonButton_ I.OnIonFocus (Effect Unit) where
  attr I.OnIonFocus value = unsafeAttribute
    { key: "ionFocus", value: cb' (Cb (const (value $> true))) }

instance Attr IonButton_ I.OnIonFocus (Effect Boolean) where
  attr I.OnIonFocus value = unsafeAttribute
    { key: "ionFocus", value: cb' (Cb (const value)) }

simpleButton
  :: forall lock payload
   . { text :: String, click :: Effect Unit }
  -> Domable lock payload
simpleButton i = ionButton (oneOf [ click_ i.click ]) [ text_ i.text ]