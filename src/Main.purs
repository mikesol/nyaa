module Main where

import Prelude

import Control.Promise (toAffE)
import Data.Compactable (compact)
import Data.Maybe (Maybe(..))
import Data.Nullable (toMaybe)
import Deku.Toplevel (runInBody)
import Effect (Effect)
import Effect.Aff (apathize, launchAff_)
import Effect.Class (liftEffect)
import Effect.Ref as Ref
import Effect.Uncurried (mkEffectFn1, runEffectFn1)
import FRP.Event (burning, create, createO)
import Nyaa.App (app)
import Nyaa.Audio (newAudioContext)
import Nyaa.Capacitor.Utils (Platform(..), getPlatform)
import Nyaa.Custom.Pages.DeityLounge (deityLounge)
import Nyaa.Custom.Pages.IntroScreen (introScreen)
import Nyaa.Custom.Pages.Levels.AmplifyLevel (amplifyLevel)
import Nyaa.Custom.Pages.Levels.BackLevel (backLevel)
import Nyaa.Custom.Pages.Levels.CameraLevel (cameraLevel)
import Nyaa.Custom.Pages.Levels.CrushLevel (crushLevel)
import Nyaa.Custom.Pages.Levels.DazzleLevel (dazzleLevel)
import Nyaa.Custom.Pages.Levels.EqualizeLevel (equalizeLevel)
import Nyaa.Custom.Pages.Levels.GlideLevel (glideLevel)
import Nyaa.Custom.Pages.Levels.HideLevel (hideLevel)
import Nyaa.Custom.Pages.Levels.Lvl99Level (lvl99Level)
import Nyaa.Custom.Pages.Levels.RotateLevel (rotateLevel)
import Nyaa.Custom.Pages.Levels.ShowMeHowLevel (showMeHowLevel)
import Nyaa.Custom.Pages.LoungePicker (loungePicker)
import Nyaa.Custom.Pages.NewbLounge (newbLounge)
import Nyaa.Custom.Pages.PathTest (pathTest)
import Nyaa.Custom.Pages.ProLounge (proLounge)
import Nyaa.Custom.Pages.ProfilePage (profilePage)
import Nyaa.Custom.Pages.Quests.AmplifyQuest (amplifyQuest)
import Nyaa.Custom.Pages.Quests.BackQuest (backQuest)
import Nyaa.Custom.Pages.Quests.BuzzQuest (buzzQuest)
import Nyaa.Custom.Pages.Quests.CrushQuest (crushQuest)
import Nyaa.Custom.Pages.Quests.DazzleQuest (dazzleQuest)
import Nyaa.Custom.Pages.Quests.FlatQuest (flatQuest)
import Nyaa.Custom.Pages.Quests.GlideQuest (glideQuest)
import Nyaa.Custom.Pages.Quests.HideQuest (hideQuest)
import Nyaa.Custom.Pages.Quests.LVL99Quest (lvl99Quest)
import Nyaa.Custom.Pages.Quests.RotateQuest (rotateQuest)
import Nyaa.Custom.Pages.Quests.ShowMeHowQuest (showMeHowQuest)
import Nyaa.Custom.Pages.TutorialPage (tutorialPage)
import Nyaa.FRP.Dedup (dedup)
import Nyaa.Firebase.Firebase (getCurrentUser, listenToAuthStateChange, reactToNewUser, signInWithGameCenter, signInWithPlayGames)
import Nyaa.Fullscreen (androidFullScreen)
import Nyaa.Ionic.Loading (brackedWithLoading)
import Routing.Hash (getHash, setHash)

foreign import prod :: Effect Boolean
foreign import noStory :: Effect Boolean

main :: Effect Unit
main = do
  -- isProd <- prod
  fxEvent <- create
  -- isRealDeal <- noStory
  unsubProfileListener <- Ref.new (pure unit)
  authListener <- createO
  profileListener <- createO
  platform <- getPlatform
  -- authState <- burning { user: null } (dedup authListener.event)
  profileState <- burning { profile: Nothing }
    (dedup profileListener.event)
  let
    compactedProfile = compact $ map
      ( _.profile >>> case _ of
          Just p -> Just { profile: p }
          Nothing -> Nothing
      )
      profileState.event
  audioContext <- newAudioContext
  audioContextRef <- Ref.new audioContext
  launchAff_ do
    when (platform == Android) do
      toAffE androidFullScreen
    -- register components
    liftEffect do
      introScreen
        { profileState: profileState.event
        }
      tutorialPage
      flatQuest { audioContextRef }
      buzzQuest { audioContextRef }
      glideQuest { audioContextRef }
      backQuest { audioContextRef }
      showMeHowQuest { audioContextRef }
      rotateQuest { audioContextRef }
      hideQuest { audioContextRef }
      dazzleQuest { audioContextRef }
      lvl99Quest { audioContextRef }
      crushQuest { audioContextRef }
      amplifyQuest { audioContextRef }
      newbLounge
        { profileState: compactedProfile
        }
      proLounge
        { profileState: compactedProfile
        }
      deityLounge
        { profileState: compactedProfile
        }
      equalizeLevel
        { audioContextRef
        , fxEvent
        , profile: _.profile <$> compactedProfile
        }
      cameraLevel
        { audioContextRef
        , fxEvent
        , profile: _.profile <$> compactedProfile
        }
      glideLevel
        { audioContextRef
        , fxEvent
        , profile: _.profile <$> compactedProfile
        }
      backLevel
        { audioContextRef
        , fxEvent
        , profile: _.profile <$> compactedProfile
        }
      lvl99Level
        { audioContextRef
        , fxEvent
        , profile: _.profile <$> compactedProfile
        }
      rotateLevel
        { audioContextRef
        , fxEvent
        , profile: _.profile <$> compactedProfile
        }
      hideLevel
        { audioContextRef
        , fxEvent
        , profile: _.profile <$> compactedProfile
        }
      dazzleLevel
        { audioContextRef
        , fxEvent
        , profile: _.profile <$> compactedProfile
        }
      showMeHowLevel
        { audioContextRef
        , fxEvent
        , profile: _.profile <$> compactedProfile
        }
      crushLevel
        { audioContextRef
        , fxEvent
        , profile: _.profile <$> compactedProfile
        }
      amplifyLevel
        { audioContextRef
        , fxEvent
        , profile: _.profile <$> compactedProfile
        }
      loungePicker
        { profileState: compactedProfile
        }
      -- devAdmin { platform }
      pathTest
      profilePage
        { platform
        , clearProfile: runEffectFn1 profileListener.push { profile: Nothing }
        , profileState: compactedProfile
        }
    -- do this just for the init side effect
    -- isProd <- liftEffect prod
    -- unless isProd do
    --   toAffE useEmulator
    liftEffect do
      h <- getHash
      when (h == "") do
        setHash "/"
      runInBody (app audioContextRef)
      launchAff_ do
        cu <- liftEffect getCurrentUser
        liftEffect do
          runEffectFn1 authListener.push { user: cu }
          let
            profileF1 = mkEffectFn1 \{ profile } -> do
              runEffectFn1 profileListener.push { profile: Just profile }
          reactToNewUser
            { user: toMaybe cu
            , push: profileF1
            , unsubProfileListener
            }
          _ <- listenToAuthStateChange $ mkEffectFn1 \u -> do
            runEffectFn1 authListener.push { user: u }
            reactToNewUser
              { user: toMaybe u
              , push: profileF1
              , unsubProfileListener
              }
          pure unit
        apathize $ brackedWithLoading "Setting phasers on stun..." do
          case platform of
            IOS -> toAffE signInWithGameCenter
            Android -> toAffE signInWithPlayGames
            Web -> pure unit
      pure unit
