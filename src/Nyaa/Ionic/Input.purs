module Nyaa.Ionic.Input
  ( IonInput(..)
  , IonInput_(..)
  , ionInput
  , ionInput_
  )
  where


import Prelude

import Control.Plus (empty)
import Deku.Attribute (class Attr, Attribute, Cb(..), cb', prop', unsafeAttribute)
import Deku.Core (Domable)
import Deku.DOM (unsafeCustomElement)
import Deku.DOM as D
import Effect (Effect)
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Enums as E
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

data IonInput_
data IonInput

ionInput
  :: forall lock payload
   . Event (Attribute IonInput_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionInput = unsafeCustomElement "ion-input" (Proxy :: Proxy IonInput_)

ionInput_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionInput_ = ionInput empty

instance Attr IonInput_ D.Accept String where
  attr D.Accept value = unsafeAttribute { key: "accept", value: prop' value }

instance Attr IonInput_ D.Autocapitalize E.Autocapitalize where
  attr D.Autocapitalize value = unsafeAttribute { key: "autocapitalize", value: prop' (E.unAutocapitalize value) }

instance Attr IonInput_ D.Autocomplete E.Autocomplete where
  attr D.Autocomplete value = unsafeAttribute { key: "autocomplete", value: prop' (E.unAutocomplete value) }

instance Attr IonInput_ I.Autocorrect E.Autocorrect where
  attr I.Autocorrect value = unsafeAttribute { key: "autocorrect", value: prop' (E.unAutocorrect value) }

instance Attr IonInput_ D.Autofocus Boolean where
  attr D.Autofocus value = unsafeAttribute { key: "autofocus", value: prop' (if value then "true" else "false") }

instance Attr IonInput_ I.ClearInput Boolean where
  attr I.ClearInput value = unsafeAttribute { key: "clear-input", value: prop' (if value then "true" else "false") }

instance Attr IonInput_ I.ClearOnEdit Boolean where
  attr I.ClearOnEdit value = unsafeAttribute { key: "clear-on-edit", value: prop' (if value then "true" else "false") }

instance Attr IonInput_ D.Color E.Color where
  attr D.Color value = unsafeAttribute { key: "color", value: prop' (E.unColor value) }

instance Attr IonInput_ I.Debounce Number where
  attr I.Debounce value = unsafeAttribute { key: "debounce", value: prop' (show value) }

instance Attr IonInput_ D.Disabled Boolean where
  attr D.Disabled value = unsafeAttribute { key: "disabled", value: prop' (if value then "true" else "false") }

instance Attr IonInput_ I.Enterkeyhint E.Enterkeyhint where
  attr I.Enterkeyhint value = unsafeAttribute { key: "enterkeyhint", value: prop' (E.unEnterkeyhint value) }

instance Attr IonInput_ D.Inputmode E.Inputmode where
  attr D.Inputmode value = unsafeAttribute { key: "inputmode", value: prop' (E.unInputmode value) }

instance Attr IonInput_ D.Max Number where
  attr D.Max value = unsafeAttribute { key: "max", value: prop' (show value) }

instance Attr IonInput_ D.Maxlength Number where
  attr D.Maxlength value = unsafeAttribute { key: "maxlength", value: prop' (show value) }

instance Attr IonInput_ D.Min Number where
  attr D.Min value = unsafeAttribute { key: "min", value: prop' (show value) }

instance Attr IonInput_ D.Minlength Number where
  attr D.Minlength value = unsafeAttribute { key: "minlength", value: prop' (show value) }

instance Attr IonInput_ I.Mode E.Mode where
  attr I.Mode value = unsafeAttribute { key: "mode", value: prop' (E.unMode value) }

instance Attr IonInput_ I.Multiple Boolean where
  attr I.Multiple value = unsafeAttribute { key: "multiple", value: prop' (if value then "true" else "false") }

instance Attr IonInput_ D.Name String where
  attr D.Name value = unsafeAttribute { key: "name", value: prop' value }

instance Attr IonInput_ D.Pattern String where
  attr D.Pattern value = unsafeAttribute { key: "pattern", value: prop' value }

instance Attr IonInput_ D.Placeholder String where
  attr D.Placeholder value = unsafeAttribute { key: "placeholder", value: prop' value }

instance Attr IonInput_ D.Readonly Boolean where
  attr D.Readonly value = unsafeAttribute { key: "readonly", value: prop' (if value then "true" else "false") }

instance Attr IonInput_ D.Required Boolean where
  attr D.Required value = unsafeAttribute { key: "required", value: prop' (if value then "true" else "false") }

instance Attr IonInput_ D.Size Number where
  attr D.Size value = unsafeAttribute { key: "size", value: prop' (show value) }

instance Attr IonInput_ D.Spellcheck Boolean where
  attr D.Spellcheck value = unsafeAttribute { key: "spellcheck", value: prop' (if value then "true" else "false") }

instance Attr IonInput_ D.Step String where
  attr D.Step value = unsafeAttribute { key: "step", value: prop' value }

instance Attr IonInput_ D.Xtype E.InputType where
  attr D.Xtype value = unsafeAttribute { key: "type", value: prop' (E.unInputType value) }

instance Attr IonInput_ D.Value String where
  attr D.Value value = unsafeAttribute { key: "value", value: prop' value }

--

instance Attr IonInput_ I.OnIonChange Cb where
  attr I.OnIonChange value = unsafeAttribute { key: "ionChange", value: cb' value }

instance Attr IonInput_ I.OnIonChange (Effect Unit) where
  attr I.OnIonChange value = unsafeAttribute
    { key: "ionChange", value: cb' (Cb (const (value $> true))) }

instance Attr IonInput_ I.OnIonChange (Effect Boolean) where
  attr I.OnIonChange value = unsafeAttribute
    { key: "ionChange", value: cb' (Cb (const value)) }

instance Attr IonInput_ I.OnIonBlur Cb where
  attr I.OnIonBlur value = unsafeAttribute { key: "ionBlur", value: cb' value }

instance Attr IonInput_ I.OnIonBlur (Effect Unit) where
  attr I.OnIonBlur value = unsafeAttribute
    { key: "ionBlur", value: cb' (Cb (const (value $> true))) }

instance Attr IonInput_ I.OnIonBlur (Effect Boolean) where
  attr I.OnIonBlur value = unsafeAttribute
    { key: "ionBlur", value: cb' (Cb (const value)) }

instance Attr IonInput_ I.OnIonFocus Cb where
  attr I.OnIonFocus value = unsafeAttribute { key: "ionFocus", value: cb' value }

instance Attr IonInput_ I.OnIonFocus (Effect Unit) where
  attr I.OnIonFocus value = unsafeAttribute
    { key: "ionFocus", value: cb' (Cb (const (value $> true))) }

instance Attr IonInput_ I.OnIonFocus (Effect Boolean) where
  attr I.OnIonFocus value = unsafeAttribute
    { key: "ionFocus", value: cb' (Cb (const value)) }

instance Attr IonInput_ I.OnIonInput Cb where
  attr I.OnIonInput value = unsafeAttribute { key: "ionInput", value: cb' value }

instance Attr IonInput_ I.OnIonInput (Effect Unit) where
  attr I.OnIonInput value = unsafeAttribute
    { key: "ionInput", value: cb' (Cb (const (value $> true))) }

instance Attr IonInput_ I.OnIonInput (Effect Boolean) where
  attr I.OnIonInput value = unsafeAttribute
    { key: "ionInput", value: cb' (Cb (const value)) }
--
instance Attr IonInput_ D.SelfT (IonInput -> Effect Unit) where
  attr D.SelfT value = unsafeAttribute
    { key: "@self@", value: cb' (Cb (unsafeCoerce value)) }


foreign import getInputElement :: IonInput -> Effect Unit
foreign import setFocus :: IonInput -> Effect Unit