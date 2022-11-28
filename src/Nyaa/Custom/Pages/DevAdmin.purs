module Nyaa.Custom.Pages.DevAdmin where

import Prelude

import Control.Parallel (parSequence_)
import Control.Promise (Promise, toAffE)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Nyaa.Capacitor.Utils (Platform(..), getPlatform)
import Nyaa.Constants.GameCenter as GCContants
import Nyaa.Constants.PlayGames as PGConstants
import Nyaa.Firebase.Firebase (Profile(..), Profile', genericUpdate, updateViaTransaction)
import Nyaa.GameCenter (ReportableAchievement(..))
import Nyaa.GameCenter as GC
import Nyaa.PlayGames as PG
import Nyaa.Some (Some, some)
import Type.Proxy (Proxy(..))

type ProfileSetter = Some Profile' -> Some Profile'

data ProfileOp
  = ProfileSetter (Some Profile')
  | ProfileTransaction (Aff Unit)

doEndgameSuccessRitual
  :: EndgameRitual
  -> Int
  -> Aff Unit
doEndgameSuccessRitual (EndgameRitual j) i = do
  platform <- liftEffect getPlatform
  parSequence_
    [ -- firebase
      case j.modProfileAchievement of
        ProfileSetter ps -> toAffE $ genericUpdate (Profile ps)
        ProfileTransaction po -> po
    , case j.modProfileScore i of
        ProfileSetter ps -> toAffE $ genericUpdate (Profile ps)
        ProfileTransaction po -> po
    -- local
    , case j.modProfileAchievement of
        ProfileSetter ps -> toAffE $ genericUpdate (Profile ps)
        ProfileTransaction po -> po
    , case j.modProfileScore i of
        ProfileSetter ps -> toAffE $ genericUpdate (Profile ps)
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
    [ case j.modProfileScore i of
        ProfileSetter ps -> toAffE $ genericUpdate (Profile ps)
        ProfileTransaction po -> po
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
    [ case j.modProfileScore i of
        ProfileSetter ps -> toAffE $ genericUpdate (Profile ps)
        ProfileTransaction po -> po
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
  , modProfileScore: \i -> ProfileTransaction $ toAffE $ updateViaTransaction
      ( Proxy
          :: Proxy
               "highScoreTrack1"
      )
      (max i)
      i
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
  , modProfileScore: \i -> ProfileTransaction $ toAffE $ updateViaTransaction
      ( Proxy
          :: Proxy
               "highScoreTrack1"
      )
      (max i)
      i
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
  , modProfileScore: \i -> ProfileTransaction $ toAffE $ updateViaTransaction
      ( Proxy
          :: Proxy
               "highScoreTrack1"
      )
      (max i)
      i
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
  , modProfileScore: \i -> ProfileTransaction $ toAffE $ updateViaTransaction
      ( Proxy
          :: Proxy
               "highScoreTrack1"
      )
      (max i)
      i
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
  , modProfileScore: \i -> ProfileTransaction $ toAffE $ updateViaTransaction
      ( Proxy
          :: Proxy
               "highScoreTrack1"
      )
      (max i)
      i
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
  , modProfileScore: \i -> ProfileTransaction $ toAffE $ updateViaTransaction
      ( Proxy
          :: Proxy
               "highScoreTrack2"
      )
      (max i)
      i
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
  , modProfileScore: \i -> ProfileTransaction $ toAffE $ updateViaTransaction
      ( Proxy
          :: Proxy
               "highScoreTrack2"
      )
      (max i)
      i
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
  , modProfileScore: \i -> ProfileTransaction $ toAffE $ updateViaTransaction
      ( Proxy
          :: Proxy
               "highScoreTrack2"
      )
      (max i)
      i
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
  , modProfileScore: \i -> ProfileTransaction $ toAffE $ updateViaTransaction
      ( Proxy
          :: Proxy
               "highScoreTrack2"
      )
      (max i)
      i
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
  , modProfileScore: \i -> ProfileTransaction $ toAffE $ updateViaTransaction
      ( Proxy
          :: Proxy
               "highScoreTrack3"
      )
      (max i)
      i
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
  , modProfileScore: \i -> ProfileTransaction $ toAffE $ updateViaTransaction
      ( Proxy
          :: Proxy
               "highScoreTrack3"
      )
      (max i)
      i
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
        ProfileSetter ps -> toAffE $ genericUpdate (Profile ps)
        ProfileTransaction po -> po
    , case platform of
        IOS -> toAffE j.iosAchievement
        Android -> toAffE j.androidAchievement
        Web -> pure unit
    ]

