module Main where

import Prelude

import Control.Promise (toAffE)
import Data.Nullable (null, toMaybe)
import Deku.Toplevel (runInBody)
import Effect (Effect)
import Effect.Aff (apathize, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Ref as Ref
import Effect.Uncurried (mkEffectFn1, runEffectFn1)
import FRP.Event (burning, createO)
import Nyaa.App (app, storybook, storybookCC)
import Nyaa.Capacitor.Utils (Platform(..), getPlatform)
import Nyaa.Custom.Pages.AmplifyQuest (amplifyQuest)
import Nyaa.Custom.Pages.BackQuest (backQuest)
import Nyaa.Custom.Pages.CameraQuest (cameraQuest)
import Nyaa.Custom.Pages.CrushQuest (crushQuest)
import Nyaa.Custom.Pages.DazzleQuest (dazzleQuest)
import Nyaa.Custom.Pages.DeityLevel (deityLevel)
import Nyaa.Custom.Pages.DeityLounge (deityLounge)
import Nyaa.Custom.Pages.DevAdmin (devAdmin)
import Nyaa.Custom.Pages.EqualizeQuest (equalizeQuest)
import Nyaa.Custom.Pages.GlideQuest (glideQuest)
import Nyaa.Custom.Pages.HideQuest (hideQuest)
import Nyaa.Custom.Pages.IntroScreen (introScreen)
import Nyaa.Custom.Pages.LoungePicker (loungePicker)
import Nyaa.Custom.Pages.NewbLevel (newbLevel)
import Nyaa.Custom.Pages.NewbLounge (newbLounge)
import Nyaa.Custom.Pages.ProLevel (proLevel)
import Nyaa.Custom.Pages.ProLounge (proLounge)
import Nyaa.Custom.Pages.ProfilePage (profilePage)
import Nyaa.Custom.Pages.RotateQuest (rotateQuest)
import Nyaa.Custom.Pages.TutorialLevel (tutorialLevel)
import Nyaa.Custom.Pages.TutorialQuest (tutorialQuest)
import Nyaa.FRP.Dedup (dedup)
import Nyaa.Firebase.Firebase (Profile(..), gameCenterEagerAuth, getCurrentUser, listenToAuthStateChange, reactToNewUser, signInWithGameCenter, signInWithPlayGames)
import Nyaa.Fullscreen (androidFullScreen)
import Nyaa.Ionic.Loading (brackedWithLoading)
import Nyaa.Some (some)
import Routing.Hash (getHash, setHash)

foreign import prod :: Effect Boolean

main :: Effect Unit
main = do
  isProd <- prod
  unsubProfileListener <- Ref.new (pure unit)
  authListener <- createO
  profileListener <- createO
  platform <- getPlatform
  authState <- burning { user: null } (dedup authListener.event)
  profileState <- burning { profile: Profile (some {}) }
    (dedup profileListener.event)
  launchAff_ do
    when (platform == Android) do
      toAffE androidFullScreen
    -- register components
    liftEffect do
      introScreen { authState: authState.event }
      tutorialQuest
      equalizeQuest
      cameraQuest
      glideQuest
      backQuest
      rotateQuest
      hideQuest
      dazzleQuest
      crushQuest
      amplifyQuest
      newbLounge
      proLounge
      deityLounge
      tutorialLevel
      newbLevel
      proLevel
      deityLevel
      loungePicker
      devAdmin { platform }
      profilePage { platform, profileState: profileState.event }
    -- do this just for the init side effect
    -- isProd <- liftEffect prod
    -- unless isProd do
    --   toAffE useEmulator
    liftEffect do
      h <- getHash
      when (h == "") do
        setHash "/"
      if false then do
        runInBody app
      else do
        storybookCC
        runInBody storybook
      launchAff_ do
        cu <- liftEffect getCurrentUser
        liftEffect do
          runEffectFn1 authListener.push { user: cu }
          reactToNewUser
            { user: toMaybe cu
            , push: profileListener.push
            , unsubProfileListener
            }
          _ <- listenToAuthStateChange $ mkEffectFn1 \u -> do
            log ("ASCHANGE: " <> show u)
            runEffectFn1 authListener.push { user: u }
            reactToNewUser
              { user: toMaybe u
              , push: profileListener.push
              , unsubProfileListener
              }
          pure unit
        apathize $ brackedWithLoading "Setting phasers on stun..." do
          case platform of
            IOS -> toAffE signInWithGameCenter
            Android -> toAffE signInWithPlayGames
            Web -> pure unit
      pure unit