module Nyaa.Firebase.Init where

import Effect (Effect)

data FirebaseApp

foreign import fbApp :: Effect FirebaseApp