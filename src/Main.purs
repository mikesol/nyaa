module Main where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple (curry, snd)
import Data.Tuple.Nested ((/\))
import Deku.Control (switcher)
import Deku.Toplevel (runInBody)
import Effect (Effect)
import FRP.Event (create)
import Nyaa.Components.Intro (introScreen)
import Nyaa.Routing (Route(..), route)
import Routing.Duplex (parse)
import Routing.Hash (getHash, matchesWith, setHash)

main :: Effect Unit
main = do
  h <- getHash
  when (h == "") do
    setHash "/"
  routing <- create
  runInBody
    ( switcher
        ( snd >>> case _ of
            Home -> introScreen
        )
        routing.event
    )
  _ <- matchesWith (parse route) (curry routing.push)
  routing.push (Nothing /\ Home)
  pure unit