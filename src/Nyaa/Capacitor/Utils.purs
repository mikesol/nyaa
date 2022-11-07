module Nyaa.Capacitor.Utils where

import Prelude

import Effect (Effect)
import FRP.Event (Event, makeEvent)

data Platform = IOS | Android | Web
derive instance Eq Platform

foreign import getPlatformImpl :: Platform -> Platform -> Platform -> Effect Platform

getPlatform :: Effect Platform
getPlatform = getPlatformImpl Web IOS Android

getPlatformE :: Event Platform
getPlatformE = makeEvent \k -> (getPlatform >>= k) *> pure (pure unit)