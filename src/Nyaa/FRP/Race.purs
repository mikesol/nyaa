module Nyaa.FRP.Race where

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

race :: forall a. Event a -> Event a -> Event a
race l r = compact $ map (snd <<< snd) $ fold f (false /\ false /\ Nothing) (Tuple <$> ((Just <$> l) <|> pure Nothing) <*> ((Just <$> r) <|> pure Nothing))
  where
  f (false /\ false /\ _) (Nothing /\ Nothing) = false /\ false /\ Nothing
  f (false /\ false /\ _) (Nothing /\ (Just a)) = false /\ true /\ (Just a)
  f (false /\ false /\ _) ((Just a) /\ _) = true /\ false /\ (Just a)
  f (true /\ _ /\ _) ((Just a) /\ _) = true /\ false /\ (Just a)
  f (_ /\ true /\ _) (_ /\ (Just a)) = false /\ true /\ (Just a)
  f (x /\ y /\ _) _ = x /\ y /\ Nothing
