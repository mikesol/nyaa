module Nyaa.Util.Backoff where

import Prelude

import Control.Monad.Error.Class (catchError, throwError)
import Data.Time.Duration (Milliseconds)
import Effect.Aff (Aff, delay)
import Effect.Class.Console (log)
import Effect.Exception (error)

backoff :: Milliseconds -> Int -> Aff ~> Aff
backoff ms i a =
  if i < 0 then throwError (error "Backed off")
  else catchError a \e -> log (show e) *> delay ms *> backoff ms (i - 1) a