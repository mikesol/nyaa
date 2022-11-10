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
import Nyaa.App (storybook, storybookCC)
import Nyaa.Capacitor.Utils (Platform(..), getPlatform)
import Nyaa.Custom.Pages.AmplifyQuest (amplifyQuest)
import Nyaa.Custom.Pages.BackQuest (backQuest)
import Nyaa.Custom.Pages.CameraQuest (cameraQuest)
import Nyaa.Custom.Pages.CrushQuest (crushQuest)
import Nyaa.Custom.Pages.DazzleQuest (dazzleQuest)
import Nyaa.Custom.Pages.DeityLevel (deityLevel)
import Nyaa.Custom.Pages.DeityLounge (deityLounge)
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
import Nyaa.Firebase.Auth (getCurrentUser, listenToAuthStateChange, useEmulator)
import Nyaa.Firebase.Firestore (Profile(..))
import Nyaa.Firebase.Init (fbAnalytics, fbApp, fbAuth, fbDB)
import Nyaa.Fullscreen (androidFullScreen)
import Nyaa.Some (some)
import Nyaa.Vite.Env (prod)
import Routing.Hash (getHash, setHash)

main :: Effect Unit
main = do
  app <- fbApp
  analytics <- fbAnalytics app
  firestoreDB <- fbDB app
  auth <- fbAuth app
  authListener <- createO
  profileListener <- createO
  authState <- burning { user: null } authListener.event
  profileListener <- burning { profile: Profile (some {}) }
    profileListener.event
  launchAff_ do
    whenM (liftEffect (getPlatform <#> (_ == Android))) do
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
      profilePage { authState: authState.event }
    -- do this just for the init side effect
    _ <- liftEffect fbApp
    isProd <- liftEffect prod
    unless isProd do
      toAffE useEmulator
    liftEffect do
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