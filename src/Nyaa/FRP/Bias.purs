module Nyaa.FRP.Bias where

import Prelude

import Data.Compactable (compact)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Data.Tuple (Tuple(..), snd)
import Control.Alt ((<|>))
import FRP.Event (Event, fold)

left :: forall a. Event a -> Event a -> Event a
left l r = compact $ map (snd <<< snd) $ fold f (false /\ false /\ Nothing)
  ( Tuple <$> ((Just <$> l) <|> pure Nothing) <*>
      ((Just <$> r) <|> pure Nothing)
  )
  where
  f (false /\ false /\ _) (Nothing /\ Nothing) = false /\ false /\ Nothing
  f (false /\ false /\ _) (Nothing /\ (Just a)) = false /\ true /\ (Just a)
  f (false /\ false /\ _) ((Just a) /\ _) = true /\ false /\ (Just a)
  f (true /\ _ /\ _) ((Just a) /\ _) = true /\ false /\ (Just a)
  f (_ /\ true /\ _) ((Just a) /\ _) = true /\ false /\ (Just a)
  f (_ /\ true /\ _) (_ /\ b) = false /\ true /\ b
  f (x /\ y /\ _) _ = x /\ y /\ Nothing

right :: forall a. Event a -> Event a -> Event a
right l r = compact $ map (snd <<< snd) $ fold f (false /\ false /\ Nothing)
  ( Tuple <$> ((Just <$> l) <|> pure Nothing) <*>
      ((Just <$> r) <|> pure Nothing)
  )
  where
  f (false /\ false /\ _) (Nothing /\ Nothing) = false /\ false /\ Nothing
  f (false /\ false /\ _) (Nothing /\ (Just a)) = false /\ true /\ (Just a)
  f (false /\ false /\ _) ((Just a) /\ _) = true /\ false /\ (Just a)
  f (true /\ _ /\ _) (_ /\ (Just a)) = false /\ true /\ (Just a)
  f (true /\ _ /\ _) (b /\ _) = true /\ false /\ b
  f (_ /\ true /\ _) (_ /\ (Just a)) = false /\ true /\ (Just a)
  f (x /\ y /\ _) _ = x /\ y /\ Nothing
