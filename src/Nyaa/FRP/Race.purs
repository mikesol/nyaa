module Nyaa.FRP.Race where

import Prelude

import Control.Monad.ST.Internal as STRef
import Control.Monad.ST.Uncurried (mkSTFn1, mkSTFn2, runSTFn1, runSTFn2)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import FRP.Event (Event, Subscriber(..), makeLemmingEventO)

race :: forall a. Event a -> Event a -> Event a
race l r = makeLemmingEventO $ mkSTFn2 \(Subscriber s) p -> do
  winner <- STRef.new Nothing
  u0 <- runSTFn2 s l $ mkSTFn1 \i -> do
    o <- STRef.read winner
    case o of
      Nothing -> do
        _ <- STRef.write (Just (Left unit)) winner
        runSTFn1 p i
      Just (Left _) -> runSTFn1 p i
      Just (Right _) -> pure unit
  u1 <- runSTFn2 s r $ mkSTFn1 \i -> do
    o <- STRef.read winner
    case o of
      Nothing -> do
        _ <- STRef.write (Just (Right unit)) winner
        runSTFn1 p i
      Just (Right _) -> runSTFn1 p i
      Just (Left _) -> pure unit
  pure do
    u0
    u1