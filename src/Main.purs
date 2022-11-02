module Main where

import Prelude

import Control.Promise (toAffE)
import Data.Maybe (Maybe(..))
import Data.Nullable (null)
import Data.Tuple (curry, snd)
import Data.Tuple.Nested ((/\))
import Deku.Control (switcher)
import Deku.Toplevel (runInBody)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Uncurried (runEffectFn1)
import FRP.Event (burning, create, createO)
import Nyaa.Components.Intro (introScreen)
import Nyaa.FRP.Dedup (dedup)
import Nyaa.Firebase.Auth (getCurrentUser, listenToAuthStateChange, useEmulator)
import Nyaa.Firebase.Init (fbApp)
import Nyaa.Routing (Route(..), route)
import Nyaa.Vite.Env (prod)
import Routing.Duplex (parse)
import Routing.Hash (getHash, matchesWith, setHash)

main :: Effect Unit
main = launchAff_ do
  -- do this just for the init side effect
  _ <- liftEffect fbApp
  isProd <- liftEffect prod
  unless isProd do
    toAffE useEmulator
  liftEffect do
    authListener <- createO
    authState <- burning { user: null } authListener.event
    h <- getHash
    when (h == "") do
      setHash "/"
    routing <- create
    runInBody
      ( switcher
          ( snd >>> case _ of
              Home -> introScreen { authState: dedup authState.event }
          )
          routing.event
      )
    -- unsub
    _ <- matchesWith (parse route) (curry routing.push)
    routing.push (Nothing /\ Home)
    -- unsub
    -- prime the pump with the auth state just in case
    launchAff_ do
      cu <- toAffE getCurrentUser
      liftEffect do
        runEffectFn1 authListener.push { user: cu }
        _ <- listenToAuthStateChange authListener.push
        pure unit
    pure unit