module Main where

import Prelude

import Control.Promise (toAffE)
import Data.Nullable (null)
import Deku.Toplevel (runInBody)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Uncurried (runEffectFn1)
import FRP.Event (burning, createO)
import Nyaa.App (app, storybook, storybookCC)
import Nyaa.Custom.IntroScreen (introScreen)
import Nyaa.Custom.QuestPage (questPage)
import Nyaa.Firebase.Auth (getCurrentUser, listenToAuthStateChange, useEmulator)
import Nyaa.Firebase.Init (fbApp)
import Nyaa.Vite.Env (prod)
import Routing.Hash (getHash, setHash)

main :: Effect Unit
main = launchAff_ do
  -- register components
  liftEffect do
    introScreen
    questPage
      { name: "tutorial-quest"
      , img: "bg-spacecat"
      , text: "Lorem ipsum"
      , next: pure unit
      }
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
    --
    -- runInBody app
    storybookCC
    runInBody storybook
    --
    launchAff_ do
      cu <- toAffE getCurrentUser
      liftEffect do
        runEffectFn1 authListener.push { user: cu }
        _ <- listenToAuthStateChange authListener.push
        pure unit
    pure unit