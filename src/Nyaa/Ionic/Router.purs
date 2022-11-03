module Nyaa.Ionic.Router where


import Bolson.Core (Entity(..), fixed)
import Control.Plus (empty)
import Data.Array (mapWithIndex)
import Deku.Attribute (class Attr, Attribute, prop', unsafeAttribute)
import Deku.Control (elementify)
import Deku.Core (Domable(..), Domable', unsafeSetPos)
import FRP.Event (Event)
import Nyaa.Ionic.Attributes as I
import Safe.Coerce (coerce)

data IonRouter_

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
