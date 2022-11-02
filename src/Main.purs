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
import Nyaa.Firebase.Auth (getCurrentUser, listenToAuthStateChange)
import Nyaa.Routing (Route(..), route)
import Routing.Duplex (parse)
import Routing.Hash (getHash, matchesWith, setHash)

main :: Effect Unit
main = do
  authListener <- createO
  authState <- burning { user: null } authListener.event
  h <- getHash
  when (h == "") do
    setHash "/"
  routing <- create
  runInBody
    ( switcher
        ( snd >>> case _ of
            Home -> introScreen { authState: authState.event }
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