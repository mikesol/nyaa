module Nyaa.Ionic.Button where

import Prelude

import Bolson.Core (Entity(..), fixed)
import Control.Plus (empty)
import Data.Array (mapWithIndex)
import Data.Foldable (oneOf)
import Deku.Attribute (class Attr, Attribute, prop', unsafeAttribute)
import Deku.Control (elementify, text_)
import Deku.Core (Domable(..), Domable', unsafeSetPos)
import Deku.DOM as D
import Deku.Listeners (click_)
import Effect (Effect)
import FRP.Event (Event)
import Safe.Coerce (coerce)

data IonButton_

ionButton
  :: forall lock payload
   . Event (Attribute IonButton_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionButton attributes kids = Domable
  ( Element'
      ( elementify "ion-button" attributes
          ( (coerce :: Domable' lock payload -> Domable lock payload)
              (fixed (coerce (mapWithIndex unsafeSetPos kids)))
          )
      )
  )

ionButton_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionButton_ = ionButton empty

instance Attr IonButton_ D.Class String where
  attr D.Class value = unsafeAttribute { key: "class", value: prop' value }

instance Attr IonButton_ D.Style String where
  attr D.Style value = unsafeAttribute { key: "style", value: prop' value }

simpleButton
  :: forall lock payload
   . { text :: String, click :: Effect Unit }
  -> Domable lock payload
simpleButton i = ionButton (oneOf [ click_ i.click ]) [ text_ i.text ]