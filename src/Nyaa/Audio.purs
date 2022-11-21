module Nyaa.Audio where

import Prelude

import Control.Promise (Promise)
import Effect (Effect)
import Effect.Ref as Ref
import Ocarina.Interpret (close_, constant0Hack_, contextState_)
import Ocarina.WebAPI (AudioContext)

foreign import newAudioContext :: Effect AudioContext
foreign import resume :: AudioContext -> Effect (Promise Unit)

refreshAudioContext :: Ref.Ref AudioContext -> Effect Unit
refreshAudioContext r = do
  ctx <- Ref.read r
  state <- contextState_ ctx
  when (state /= "closed" && state /= "running") do
    close_ ctx
  newCtx <- newAudioContext
  void $ constant0Hack_ ctx
  Ref.write newCtx r

shutItDown :: Ref.Ref AudioContext -> Effect Unit
shutItDown r = do
  ctx <- Ref.read r
  state <- contextState_ ctx
  when (state /= "closed" )
    do
      close_ ctx
