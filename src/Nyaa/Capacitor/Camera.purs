module Nyaa.Capacitor.Camera where

import Control.Promise (Promise)
import Data.ArrayBuffer.Types (Uint8Array)
import Effect (Effect)

foreign import takePicture
  :: Effect (Promise { webPath :: String, buffer :: Uint8Array })