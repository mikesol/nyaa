module Nyaa.FRP.MemoBeh where

import Prelude

import Bolson.Core (envy)
import Control.Monad.ST.Class (liftST)
import Control.Monad.ST.Internal as STRef
import Data.Foldable (traverse_)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested (type (/\), (/\))
import Deku.Core (Domable(..))
import Effect (Effect)
import FRP.Event (Event, create, makeEvent, subscribe)

useMemoBeh
  :: forall l p a. ((a -> Effect Unit) /\ Event a -> Domable l p) -> Domable l p
useMemoBeh f = Domable $ envy $ makeEvent \k -> do
  { push, event } <- create
  current <- liftST (STRef.new Nothing)
  let writeVal v = liftST (STRef.write (Just v) current)
  let
    push' i = do
      _ <- writeVal i
      push i
  let
    event' = makeEvent \k' -> do
      val <- liftST (STRef.read current)
      traverse_ k' val
      subscribe event k'
  k ((\(Domable x) -> x) (f (push' /\ event')))
  subscribe event (\v -> writeVal v *> push' v)