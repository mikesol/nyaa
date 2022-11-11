module Nyaa.Audio where

import Effect (Effect)
import Ocarina.WebAPI (AudioContext)

foreign import newAudioContext :: Effect AudioContext
