module Nyaa.Ionic.Content where

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

data IonContent_

ionContent
  :: forall lock payload
   . Event (Attribute IonContent_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionContent attributes kids = Domable
  ( Element'
      ( elementify "ion-content" attributes
          ( (coerce :: Domable' lock payload -> Domable lock payload)
              (fixed (coerce (mapWithIndex unsafeSetPos kids)))
          )
      )
  )

ionContent_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionContent_ = ionContent empty

instance Attr IonContent_ D.Class String where
  attr D.Class value = unsafeAttribute { key: "class", value: prop' value }

instance Attr IonContent_ D.Style String where
  attr D.Style value = unsafeAttribute { key: "style", value: prop' value }

simpleContent
  :: forall lock payload
   . { text :: String, click :: Effect Unit }
  -> Domable lock payload
simpleContent i = ionContent (oneOf [ click_ i.click ]) [ text_ i.text ]