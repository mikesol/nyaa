module Nyaa.FRP.First where

import Prelude

import Control.Monad.ST.Internal as STRef
import Control.Monad.ST.Uncurried (mkSTFn1, mkSTFn2, runSTFn1, runSTFn2)
import Data.Compactable (compact)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Data.Tuple (Tuple(..))
import Control.Alt((<|>))
import Data.Tuple (snd)
import FRP.Event (Event, Subscriber(..), fold, makeLemmingEventO)

first :: forall a. Event a -> Event a
first l = compact $ map snd $ fold f (false /\ Nothing) (Just <$> l)
  where
  f (false /\ _) a = true /\ a
  f (true /\ _) _ = true /\ Nothing
