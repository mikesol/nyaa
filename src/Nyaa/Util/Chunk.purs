module Nyaa.Util.Chunk where

import Prelude

import Data.Array (groupBy)
import Data.Array.NonEmpty (NonEmptyArray)
import Data.FunctorWithIndex (mapWithIndex)
import Data.Tuple (Tuple(..), snd)
import Data.Tuple.Nested ((/\))

chunk :: forall a. Int -> Array a -> Array (NonEmptyArray a)
chunk i a = (map <<< map) snd
  $ groupBy (\(x /\ _) (y /\ _) -> (x / i) == (y / i))
  $ mapWithIndex Tuple a