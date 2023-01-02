module Nyaa.Custom.Pages.DevAdmin where

import Prelude

import Control.Alt ((<|>))
import Control.Parallel (parSequence_, parallel, sequential)
import Control.Promise (Promise, toAffE)
import Data.Foldable (for_, sequence_)
import Data.Maybe (Maybe(..))
import Data.Symbol (class IsSymbol, reflectSymbol)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Nyaa.Capacitor.Preferences (getPreference, setPreference, setPreferencesFromSome)
import Nyaa.Capacitor.Utils (Platform(..), getPlatform)
import Nyaa.Constants.GameCenter as GCContants
import Nyaa.Constants.PlayGames as PGConstants
import Nyaa.Firebase.Firebase (Profile(..), Profile', genericUpdate, updateViaTransaction)
import Nyaa.GameCenter (ReportableAchievement(..))
import Nyaa.GameCenter as GC
import Nyaa.PlayGames as PG
import Nyaa.Some (Some, get,  some)
import Prim.Row (class Cons)
import Simple.JSON as JSON
import Type.Proxy (Proxy(..))

type ProfileSetter = Some Profile' -> Some Profile'

data ProfileOp
  = ProfileSetter (Some Profile')
  | ProfileTransaction (Aff Unit)

updateViaSetter :: Some Profile' -> Aff Unit
updateViaSetter ps = sequential
  ( (parallel $ toAffE $ genericUpdate (Profile ps)) <|>
      (parallel $ setPreferencesFromSome ps)
  )

trackProfileTransaction
  :: forall key67 r69 a70
   . IsSymbol key67
  => Cons key67 a70 r69 Profile'
  => Ord a70
  => JSON.WriteForeign a70
  => JSON.ReadForeign a70
  => Proxy key67
  -> a70
  -> ProfileOp
trackProfileTransaction px i = ProfileTransaction $ sequential
  ( ( parallel
        ( toAffE $
            updateViaTransaction
              px
              (max i)
              i
        )
    ) <|>
      ( parallel do
          v <- toAffE $ getPreference (reflectSymbol px)
          case v of
            Nothing -> toAffE $ setPreference (reflectSymbol px) $
              JSON.writeJSON i
            Just y -> case JSON.readJSON_ y of
              Nothing -> pure unit
              Just y' -> toAffE $ setPreference (reflectSymbol px) $
                JSON.writeJSON (max i y')
      )
  )

track1ProfileTransaction :: Int -> ProfileOp
track1ProfileTransaction = trackProfileTransaction
  ( Proxy
      :: Proxy
           "highScoreTrack1"
  )

track2ProfileTransaction :: Int -> ProfileOp
track2ProfileTransaction = trackProfileTransaction
  ( Proxy
      :: Proxy
           "highScoreTrack2"
  )

track3ProfileTransaction :: Int -> ProfileOp
track3ProfileTransaction = trackProfileTransaction
  ( Proxy
      :: Proxy
           "highScoreTrack3"
  )

onlyDoAchievementForEndgameRitual
  :: EndgameRitual
  -> Aff Unit
onlyDoAchievementForEndgameRitual (EndgameRitual j) = do
  platform <- liftEffect getPlatform
  parSequence_
    [ -- firebase + local
      case j.modProfileAchievement of
        ProfileSetter ps -> updateViaSetter ps
        ProfileTransaction po -> po
    -- platform
    , case platform of
        IOS -> toAffE j.iosAchievement
        Android -> toAffE j.androidAchievement
        Web -> pure unit
    ]

doEndgameSuccessRitual
  :: EndgameRitual
  -> Int
  -> Aff Unit
doEndgameSuccessRitual (EndgameRitual j) i = do
  platform <- liftEffect getPlatform
  parSequence_
    [ -- firebase + local
      case j.modProfileAchievement of
        ProfileSetter ps -> updateViaSetter ps
        ProfileTransaction po -> po
    , case j.modProfileScore i of
        ProfileSetter ps -> updateViaSetter ps
        ProfileTransaction po -> po
    -- platform
    , case platform of
        IOS -> toAffE j.iosAchievement
        Android -> toAffE j.androidAchievement
        Web -> pure unit
    , case platform of
        IOS -> toAffE $ j.iosScore i
        Android -> toAffE $ j.androidScore i
        Web -> pure unit
    ]

doScoreOnlyRitual
  :: ScoreOnly
  -> Int
  -> Aff Unit
doScoreOnlyRitual (ScoreOnly j) i = do
  platform <- liftEffect getPlatform
  parSequence_
    [ -- firebase + local
      case j.modProfileScore i of
        ProfileSetter ps -> updateViaSetter ps
        ProfileTransaction po -> po
    -- platform
    , case platform of
        IOS -> toAffE $ j.iosScore i
        Android -> toAffE $ j.androidScore i
        Web -> pure unit
    ]

doEndgameFailureRitual
  :: EndgameRitual
  -> Int
  -> Aff Unit
doEndgameFailureRitual (EndgameRitual j) i = do
  platform <- liftEffect getPlatform
  parSequence_
    [ -- firebase + local
      case j.modProfileScore i of
        ProfileSetter ps -> updateViaSetter ps
        ProfileTransaction po -> po
    -- platform
    , case platform of
        IOS -> toAffE $ j.iosScore i
        Android -> toAffE $ j.androidScore i
        Web -> pure unit
    ]

newtype EndgameRitual = EndgameRitual
  { androidAchievement :: Effect (Promise Unit)
  , iosAchievement :: Effect (Promise Unit)
  , modProfileAchievement :: ProfileOp
  , androidScore :: Int -> Effect (Promise Unit)
  , iosScore :: Int -> Effect (Promise Unit)
  , modProfileScore :: Int -> ProfileOp
  }

flatEndgameRitual :: EndgameRitual
flatEndgameRitual = EndgameRitual
  { modProfileAchievement: ProfileSetter $ some { flat: true }
  , iosAchievement: GC.reportAchievements
      { achievements:
          [ ReportableAchievement
              { achievementID: GCContants.flatAchievement
              , percentComplete: 100.0
              }
          ]
      }
  , androidAchievement: PG.unlockAchievement
      { achievementID: PGConstants.flatAchievement }
  , modProfileScore: track1ProfileTransaction
  , iosScore: \i -> GC.submitScore
      { leaderboardID: GCContants.track1LeaderboardID
      , points: i
      }
  , androidScore: \i -> PG.submitScore
      { leaderboardID: PGConstants.track1LeaderboardID, amount: i }
  }

buzzEndgameRitual :: EndgameRitual
buzzEndgameRitual = EndgameRitual
  { modProfileAchievement: ProfileSetter $ some { buzz: true }
  , iosAchievement: GC.reportAchievements
      { achievements:
          [ ReportableAchievement
              { achievementID: GCContants.buzzAchievement
              , percentComplete: 100.0
              }
          ]
      }
  , androidAchievement: PG.unlockAchievement
      { achievementID: PGConstants.buzzAchievement }
  , modProfileScore: track1ProfileTransaction
  , iosScore: \i -> GC.submitScore
      { leaderboardID: GCContants.track1LeaderboardID
      , points: i
      }
  , androidScore: \i -> PG.submitScore
      { leaderboardID: PGConstants.track1LeaderboardID, amount: i }
  }

glideEndgameRitual :: EndgameRitual
glideEndgameRitual = EndgameRitual
  { modProfileAchievement: ProfileSetter $ some { glide: true }
  , iosAchievement: GC.reportAchievements
      { achievements:
          [ ReportableAchievement
              { achievementID: GCContants.glideAchievement
              , percentComplete: 100.0
              }
          ]
      }
  , androidAchievement: PG.unlockAchievement
      { achievementID: PGConstants.glideAchievement }
  , modProfileScore: track1ProfileTransaction
  , iosScore: \i -> GC.submitScore
      { leaderboardID: GCContants.track1LeaderboardID
      , points: i
      }
  , androidScore: \i -> PG.submitScore
      { leaderboardID: PGConstants.track1LeaderboardID, amount: i }
  }

backEndgameRitual :: EndgameRitual
backEndgameRitual = EndgameRitual
  { modProfileAchievement: ProfileSetter $ some { back: true }
  , iosAchievement: GC.reportAchievements
      { achievements:
          [ ReportableAchievement
              { achievementID: GCContants.backAchievement
              , percentComplete: 100.0
              }
          ]
      }
  , androidAchievement: PG.unlockAchievement
      { achievementID: PGConstants.backAchievement }
  , modProfileScore: track1ProfileTransaction
  , iosScore: \i -> GC.submitScore
      { leaderboardID: GCContants.track1LeaderboardID
      , points: i
      }
  , androidScore: \i -> PG.submitScore
      { leaderboardID: PGConstants.track1LeaderboardID, amount: i }
  }

track2EndgameRitual :: EndgameRitual
track2EndgameRitual = EndgameRitual
  { modProfileAchievement: ProfileSetter $ some { track2: true }
  , iosAchievement: GC.reportAchievements
      { achievements:
          [ ReportableAchievement
              { achievementID: GCContants.track2Achievement
              , percentComplete: 100.0
              }
          ]
      }
  , androidAchievement: PG.unlockAchievement
      { achievementID: PGConstants.track2Achievement }
  , modProfileScore: track1ProfileTransaction
  , iosScore: \i -> GC.submitScore
      { leaderboardID: GCContants.track1LeaderboardID
      , points: i
      }
  , androidScore: \i -> PG.submitScore
      { leaderboardID: PGConstants.track1LeaderboardID, amount: i }
  }

rotateEndgameRitual :: EndgameRitual
rotateEndgameRitual = EndgameRitual
  { modProfileAchievement: ProfileSetter $ some { rotate: true }
  , iosAchievement: GC.reportAchievements
      { achievements:
          [ ReportableAchievement
              { achievementID: GCContants.rotateAchievement
              , percentComplete: 100.0
              }
          ]
      }
  , androidAchievement: PG.unlockAchievement
      { achievementID: PGConstants.rotateAchievement }
  , modProfileScore: track2ProfileTransaction
  , iosScore: \i -> GC.submitScore
      { leaderboardID: GCContants.track2LeaderboardID
      , points: i
      }
  , androidScore: \i -> PG.submitScore
      { leaderboardID: PGConstants.track2LeaderboardID, amount: i }
  }

hideEndgameRitual :: EndgameRitual
hideEndgameRitual = EndgameRitual
  { modProfileAchievement: ProfileSetter $ some { hide: true }
  , iosAchievement: GC.reportAchievements
      { achievements:
          [ ReportableAchievement
              { achievementID: GCContants.hideAchievement
              , percentComplete: 100.0
              }
          ]
      }
  , androidAchievement: PG.unlockAchievement
      { achievementID: PGConstants.hideAchievement }
  , modProfileScore: track2ProfileTransaction
  , iosScore: \i -> GC.submitScore
      { leaderboardID: GCContants.track2LeaderboardID
      , points: i
      }
  , androidScore: \i -> PG.submitScore
      { leaderboardID: PGConstants.track2LeaderboardID, amount: i }
  }

dazzleEndgameRitual :: EndgameRitual
dazzleEndgameRitual = EndgameRitual
  { modProfileAchievement: ProfileSetter $ some { dazzle: true }
  , iosAchievement: GC.reportAchievements
      { achievements:
          [ ReportableAchievement
              { achievementID: GCContants.dazzleAchievement
              , percentComplete: 100.0
              }
          ]
      }
  , androidAchievement: PG.unlockAchievement
      { achievementID: PGConstants.dazzleAchievement }
  , modProfileScore: track2ProfileTransaction
  , iosScore: \i -> GC.submitScore
      { leaderboardID: GCContants.track2LeaderboardID
      , points: i
      }
  , androidScore: \i -> PG.submitScore
      { leaderboardID: PGConstants.track2LeaderboardID, amount: i }
  }

track3EndgameRitual :: EndgameRitual
track3EndgameRitual = EndgameRitual
  { modProfileAchievement: ProfileSetter $ some { track3: true }
  , iosAchievement: GC.reportAchievements
      { achievements:
          [ ReportableAchievement
              { achievementID: GCContants.track3Achievement
              , percentComplete: 100.0
              }
          ]
      }
  , androidAchievement: PG.unlockAchievement
      { achievementID: PGConstants.track3Achievement }
  , modProfileScore: track2ProfileTransaction
  , iosScore: \i -> GC.submitScore
      { leaderboardID: GCContants.track2LeaderboardID
      , points: i
      }
  , androidScore: \i -> PG.submitScore
      { leaderboardID: PGConstants.track2LeaderboardID, amount: i }
  }

crushEndgameRitual :: EndgameRitual
crushEndgameRitual = EndgameRitual
  { modProfileAchievement: ProfileSetter $ some { crush: true }
  , iosAchievement: GC.reportAchievements
      { achievements:
          [ ReportableAchievement
              { achievementID: GCContants.crushAchievement
              , percentComplete: 100.0
              }
          ]
      }
  , androidAchievement: PG.unlockAchievement
      { achievementID: PGConstants.crushAchievement }
  , modProfileScore: track3ProfileTransaction
  , iosScore: \i -> GC.submitScore
      { leaderboardID: GCContants.track3LeaderboardID
      , points: i
      }
  , androidScore: \i -> PG.submitScore
      { leaderboardID: PGConstants.track3LeaderboardID, amount: i }
  }

amplifyEndgameRitual :: EndgameRitual
amplifyEndgameRitual = EndgameRitual
  { modProfileAchievement: ProfileSetter $ some { amplify: true }
  , iosAchievement: GC.reportAchievements
      { achievements:
          [ ReportableAchievement
              { achievementID: GCContants.amplifyAchievement
              , percentComplete: 100.0
              }
          ]
      }
  , androidAchievement: PG.unlockAchievement
      { achievementID: PGConstants.amplifyAchievement }
  , modProfileScore: track3ProfileTransaction
  , iosScore: \i -> GC.submitScore
      { leaderboardID: GCContants.track3LeaderboardID
      , points: i
      }
  , androidScore: \i -> PG.submitScore
      { leaderboardID: PGConstants.track3LeaderboardID, amount: i }
  }

newtype ScorelessAchievement = ScorelessAchievement
  { androidAchievement :: Effect (Promise Unit)
  , iosAchievement :: Effect (Promise Unit)
  , modProfileAchievement :: ProfileOp
  }

newtype ScoreOnly = ScoreOnly
  { androidScore :: Int -> Effect (Promise Unit)
  , iosScore :: Int -> Effect (Promise Unit)
  , modProfileScore :: Int -> ProfileOp
  }

endgameRitualToScoreOnly :: EndgameRitual -> ScoreOnly
endgameRitualToScoreOnly
  (EndgameRitual { androidScore, iosScore, modProfileScore }) = ScoreOnly
  { androidScore, iosScore, modProfileScore }

tutorialAchievement :: ScorelessAchievement
tutorialAchievement = ScorelessAchievement
  { modProfileAchievement: ProfileSetter $ some { hasCompletedTutorial: true }
  , iosAchievement: GC.reportAchievements
      { achievements:
          [ ReportableAchievement
              { achievementID: GCContants.tutorialAchievement
              , percentComplete: 100.0
              }
          ]
      }
  , androidAchievement: PG.unlockAchievement
      { achievementID: PGConstants.tutorialAchievement }
  }

track1Achievement :: ScorelessAchievement
track1Achievement = ScorelessAchievement
  { modProfileAchievement: ProfileSetter $ some { track1: true }
  , iosAchievement: GC.reportAchievements
      { achievements:
          [ ReportableAchievement
              { achievementID: GCContants.track1Achievement
              , percentComplete: 100.0
              }
          ]
      }
  , androidAchievement: PG.unlockAchievement
      { achievementID: PGConstants.track1Achievement }
  }

doScorelessAchievement
  :: ScorelessAchievement
  -> Aff Unit
doScorelessAchievement (ScorelessAchievement j) = do
  platform <- liftEffect getPlatform
  parSequence_
    [ case j.modProfileAchievement of
        ProfileSetter ps -> updateViaSetter ps
        ProfileTransaction po -> po
    , case platform of
        IOS -> toAffE j.iosAchievement
        Android -> toAffE j.androidAchievement
        Web -> pure unit
    ]

-- todo
-- for now this treats updates as idempotent
-- but it means that a high score will be written to pg and gc on every sign in
-- do we care?
-- was gonna be parSequence_, but as this is backgroundy we can let it run long
updateAchievementsAndScoresFromProfile :: Profile -> Aff Unit
updateAchievementsAndScoresFromProfile (Profile p) = sequence_
  [ for_ (get (Proxy :: _ "hasCompletedTutorial") p)
      (if _ then doScorelessAchievement tutorialAchievement else pure unit)
  , for_ (get (Proxy :: _ "track1") p)
      (if _ then doScorelessAchievement track1Achievement else pure unit)
  , for_ (get (Proxy :: _ "flat") p)
      ( if _ then onlyDoAchievementForEndgameRitual flatEndgameRitual
        else pure unit
      )
  , for_ (get (Proxy :: _ "buzz") p)
      ( if _ then onlyDoAchievementForEndgameRitual buzzEndgameRitual
        else pure unit
      )
  , for_ (get (Proxy :: _ "glide") p)
      ( if _ then onlyDoAchievementForEndgameRitual glideEndgameRitual
        else pure unit
      )
  , for_ (get (Proxy :: _ "back") p)
      ( if _ then onlyDoAchievementForEndgameRitual backEndgameRitual
        else pure unit
      )
  , for_ (get (Proxy :: _ "track2") p)
      ( if _ then onlyDoAchievementForEndgameRitual track2EndgameRitual
        else pure unit
      )
  , for_ (get (Proxy :: _ "rotate") p)
      ( if _ then onlyDoAchievementForEndgameRitual rotateEndgameRitual
        else pure unit
      )
  , for_ (get (Proxy :: _ "hide") p)
      ( if _ then onlyDoAchievementForEndgameRitual hideEndgameRitual
        else pure unit
      )
  , for_ (get (Proxy :: _ "dazzle") p)
      ( if _ then onlyDoAchievementForEndgameRitual dazzleEndgameRitual
        else pure unit
      )
  , for_ (get (Proxy :: _ "track3") p)
      ( if _ then onlyDoAchievementForEndgameRitual track3EndgameRitual
        else pure unit
      )
  , for_ (get (Proxy :: _ "crush") p)
      ( if _ then onlyDoAchievementForEndgameRitual crushEndgameRitual
        else pure unit
      )
  , for_ (get (Proxy :: _ "amplify") p)
      ( if _ then onlyDoAchievementForEndgameRitual amplifyEndgameRitual
        else pure unit
      )
  , for_ (get (Proxy :: _ "highScoreTrack1") p)
      (doScoreOnlyRitual (endgameRitualToScoreOnly backEndgameRitual))
  , for_ (get (Proxy :: _ "highScoreTrack2") p)
      (doScoreOnlyRitual (endgameRitualToScoreOnly dazzleEndgameRitual))
  , for_ (get (Proxy :: _ "highScoreTrack3") p)
      (doScoreOnlyRitual (endgameRitualToScoreOnly amplifyEndgameRitual))
  ]