module Nyaa.Ionic.App where


import Control.Plus (empty)
import Deku.Attribute (Attribute)
import Deku.Core (Domable)
import Deku.DOM (unsafeCustomElement)
import FRP.Event (Event)
import Type.Proxy (Proxy(..))

data IonApp_

ionApp
  :: forall lock payload
   . Event (Attribute IonApp_)
  -> Array (Domable lock payload)
  -> Domable lock payload
ionApp = unsafeCustomElement "ion-app" (Proxy :: Proxy IonApp_)

ionApp_
  :: forall lock payload
   . Array (Domable lock payload)
  -> Domable lock payload
ionApp_ = ionApp empty
