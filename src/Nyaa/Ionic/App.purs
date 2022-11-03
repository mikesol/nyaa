module Nyaa.Ionic.App where


import Bolson.Core (Entity(..), fixed)
import Control.Plus (empty)
import Data.Array (mapWithIndex)
import Deku.Attribute (Attribute)
import Deku.Control (elementify)
import Deku.Core (Domable(..), Domable', unsafeSetPos)
import FRP.Event (Event)
import Safe.Coerce (coerce)

data IonApp_

ionApp
  :: forall lock payload
   . Event (Attribute IonApp_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionApp attributes kids = Domable
  ( Element'
      ( elementify "ion-app" attributes
          ( (coerce :: Domable' lock payload -> Domable lock payload)
              (fixed (coerce (mapWithIndex unsafeSetPos kids)))
          )
      )
  )

ionApp_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionApp_ = ionApp empty
