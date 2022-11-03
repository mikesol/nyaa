module Nyaa.Capacitor.Utils where

import Effect (Effect)

data Platform = IOS | Android | Web

foreign import getPlatformImpl :: Platform -> Platform -> Platform -> Effect Platform

getPlatform :: Effect Platform
getPlatform = getPlatformImpl Web IOS Android