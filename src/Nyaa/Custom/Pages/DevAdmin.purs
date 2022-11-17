module Nyaa.Custom.Pages.DevAdmin where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.Array.NonEmpty (toArray)
import Data.Foldable (oneOf)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.Listeners (click_)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Nyaa.Capacitor.Utils (Platform(..))
import Nyaa.Constants.GameCenter as GCContants
import Nyaa.Constants.PlayGames as PGConstants
import Nyaa.Firebase.Firebase (Profile(..), Profile', genericUpdate, updateViaTransaction)
import Nyaa.GameCenter (ReportableAchievement(..))
import Nyaa.GameCenter as GC
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.BackButton (ionBackButton)
import Nyaa.Ionic.Button (ionButton)
import Nyaa.Ionic.Buttons (ionButtons)
import Nyaa.Ionic.Col (ionCol_)
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent)
import Nyaa.Ionic.Grid (ionGrid_)
import Nyaa.Ionic.Header (ionHeader)
import Nyaa.Ionic.Row (ionRow_)
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)
import Nyaa.PlayGames as PG
import Nyaa.Some (Some, some)
import Nyaa.Util.Chunk (chunk)
import Type.Proxy (Proxy(..))

type ProfileSetter = Some Profile' -> Some Profile'

data ProfileOp = ProfileSetter (Some Profile') | ProfileTransaction (Effect (Promise Unit))


doBusinessLogic
  :: forall r
   . Platform
  -> { android :: Effect (Promise Unit)
     , ios :: Effect (Promise Unit)
     , modProfile :: ProfileOp
     | r
     }
  -> Aff Unit
doBusinessLogic platform j = do
  case j.modProfile of
    ProfileSetter ps -> toAffE $ genericUpdate (Profile ps)
    ProfileTransaction po -> toAffE po
  case platform of
    IOS -> toAffE j.ios
    Android -> toAffE j.android
    Web -> pure unit

businessLogic
  :: Array
       { android :: Effect (Promise Unit)
       , ios :: Effect (Promise Unit)
       , text :: String
       , modProfile :: ProfileOp
       }
businessLogic =
  [ { text: "Unlock tutorial"
    , modProfile: ProfileSetter $ some { hasCompletedTutorial: true }
    , ios: GC.reportAchievements
        { achievements:
            [ ReportableAchievement
                { achievementID: GCContants.tutorialAchievement
                , percentComplete: 100.0
                }
            ]
        }
    , android: PG.unlockAchievement
        { achievementID: PGConstants.tutorialAchievement }
    }
  , { text: "Unlock track 1"
    , modProfile: ProfileSetter $ some { track1: true }
    , ios: GC.reportAchievements
        { achievements:
            [ ReportableAchievement
                { achievementID: GCContants.track1Achievement
                , percentComplete: 100.0
                }
            ]
        }
    , android: PG.unlockAchievement
        { achievementID: PGConstants.track1Achievement }
    }
  , { text: "Unlock flat"
    , modProfile: ProfileSetter $ some { flat: true }
    , ios: GC.reportAchievements
        { achievements:
            [ ReportableAchievement
                { achievementID: GCContants.flatAchievement
                , percentComplete: 100.0
                }
            ]
        }
    , android: PG.unlockAchievement
        { achievementID: PGConstants.flatAchievement }
    }
  , { text: "Unlock buzz"
    , modProfile: ProfileSetter $ some { buzz: true }
    , ios: GC.reportAchievements
        { achievements:
            [ ReportableAchievement
                { achievementID: GCContants.buzzAchievement
                , percentComplete: 100.0
                }
            ]
        }
    , android: PG.unlockAchievement
        { achievementID: PGConstants.buzzAchievement }
    }
  , { text: "Unlock glide"
    , modProfile: ProfileSetter $ some { glide: true }
    , ios: GC.reportAchievements
        { achievements:
            [ ReportableAchievement
                { achievementID: GCContants.glideAchievement
                , percentComplete: 100.0
                }
            ]
        }
    , android: PG.unlockAchievement
        { achievementID: PGConstants.glideAchievement }
    }
  , { text: "Unlock back"
    , modProfile: ProfileSetter $ some { back: true }
    , ios: GC.reportAchievements
        { achievements:
            [ ReportableAchievement
                { achievementID: GCContants.backAchievement
                , percentComplete: 100.0
                }
            ]
        }
    , android: PG.unlockAchievement
        { achievementID: PGConstants.backAchievement }
    }
  , { text: "Unlock track 2"
    , modProfile: ProfileSetter $ some { track2: true }
    , ios: GC.reportAchievements
        { achievements:
            [ ReportableAchievement
                { achievementID: GCContants.track2Achievement
                , percentComplete: 100.0
                }
            ]
        }
    , android: PG.unlockAchievement
        { achievementID: PGConstants.track2Achievement }
    }
  , { text: "Unlock rotate"
    , modProfile: ProfileSetter $ some { rotate: true }
    , ios: GC.reportAchievements
        { achievements:
            [ ReportableAchievement
                { achievementID: GCContants.rotateAchievement
                , percentComplete: 100.0
                }
            ]
        }
    , android: PG.unlockAchievement
        { achievementID: PGConstants.rotateAchievement }
    }
  , { text: "Unlock hide"
    , modProfile: ProfileSetter $ some { hide: true }
    , ios: GC.reportAchievements
        { achievements:
            [ ReportableAchievement
                { achievementID: GCContants.hideAchievement
                , percentComplete: 100.0
                }
            ]
        }
    , android: PG.unlockAchievement
        { achievementID: PGConstants.hideAchievement }
    }
  , { text: "Unlock dazzle"
    , modProfile: ProfileSetter $ some { dazzle: true }
    , ios: GC.reportAchievements
        { achievements:
            [ ReportableAchievement
                { achievementID: GCContants.dazzleAchievement
                , percentComplete: 100.0
                }
            ]
        }
    , android: PG.unlockAchievement
        { achievementID: PGConstants.dazzleAchievement }
    }
  , { text: "Unlock track 3"
    , modProfile: ProfileSetter $ some { track3: true }
    , ios: GC.reportAchievements
        { achievements:
            [ ReportableAchievement
                { achievementID: GCContants.track3Achievement
                , percentComplete: 100.0
                }
            ]
        }
    , android: PG.unlockAchievement
        { achievementID: PGConstants.track3Achievement }
    }
  , { text: "Unlock crush"
    , modProfile: ProfileSetter $ some { crush: true }
    , ios: GC.reportAchievements
        { achievements:
            [ ReportableAchievement
                { achievementID: GCContants.crushAchievement
                , percentComplete: 100.0
                }
            ]
        }
    , android: PG.unlockAchievement
        { achievementID: PGConstants.crushAchievement }
    }
  , { text: "Unlock amplify"
    , modProfile: ProfileSetter $ some { amplify: true }
    , ios: GC.reportAchievements
        { achievements:
            [ ReportableAchievement
                { achievementID: GCContants.amplifyAchievement
                , percentComplete: 100.0
                }
            ]
        }
    , android: PG.unlockAchievement
        { achievementID: PGConstants.amplifyAchievement }
    }
  --
  , { text: "Add 10 @ lb 1"
    , modProfile: ProfileTransaction $ updateViaTransaction (Proxy :: _ "highScoreTrack1") (max 10) 10
    , ios: GC.submitScore
        { leaderboardID: GCContants.track1LeaderboardID
        , points: 10
        }
    , android: PG.submitScore
        { leaderboardID: PGConstants.track1LeaderboardID, amount: 10 }
    }
  , { text: "Add 100 @ lb 1"
    , modProfile: ProfileTransaction $ updateViaTransaction (Proxy :: _ "highScoreTrack1") (max 100) 100
    , ios: GC.submitScore
        { leaderboardID: GCContants.track1LeaderboardID
        , points: 100
        }
    , android: PG.submitScore
        { leaderboardID: PGConstants.track1LeaderboardID, amount: 100 }
    }
  , { text: "Add 1000 @ lb 1"
    , modProfile: ProfileTransaction $ updateViaTransaction (Proxy :: _ "highScoreTrack1") (max 1000) 1000
    , ios: GC.submitScore
        { leaderboardID: GCContants.track1LeaderboardID
        , points: 1000
        }
    , android: PG.submitScore
        { leaderboardID: PGConstants.track1LeaderboardID, amount: 1000 }
    }
  --
  --
  , { text: "Add 10 @ lb 2"
    , modProfile: ProfileTransaction $ updateViaTransaction (Proxy :: _ "highScoreTrack2") (max 10) 10
    , ios: GC.submitScore
        { leaderboardID: GCContants.track2LeaderboardID
        , points: 10
        }
    , android: PG.submitScore
        { leaderboardID: PGConstants.track2LeaderboardID, amount: 10 }
    }
  , { text: "Add 100 @ lb 2"
    , modProfile: ProfileTransaction $ updateViaTransaction (Proxy :: _ "highScoreTrack2") (max 100) 100
    , ios: GC.submitScore
        { leaderboardID: GCContants.track2LeaderboardID
        , points: 100
        }
    , android: PG.submitScore
        { leaderboardID: PGConstants.track2LeaderboardID, amount: 100 }
    }
  , { text: "Add 1000 @ lb 2"
    , modProfile: ProfileTransaction $ updateViaTransaction (Proxy :: _ "highScoreTrack2") (max 1000) 1000
    , ios: GC.submitScore
        { leaderboardID: GCContants.track2LeaderboardID
        , points: 1000
        }
    , android: PG.submitScore
        { leaderboardID: PGConstants.track2LeaderboardID, amount: 1000 }
    }
  --
  --
  , { text: "Add 10 @ lb 3"
    , modProfile: ProfileTransaction $ updateViaTransaction (Proxy :: _ "highScoreTrack3") (max 10) 10
    , ios: GC.submitScore
        { leaderboardID: GCContants.track3LeaderboardID
        , points: 10
        }
    , android: PG.submitScore
        { leaderboardID: PGConstants.track3LeaderboardID, amount: 10 }
    }
  , { text: "Add 100 @ lb 3"
    , modProfile: ProfileTransaction $ updateViaTransaction (Proxy :: _ "highScoreTrack3") (max 100) 100
    , ios: GC.submitScore
        { leaderboardID: GCContants.track3LeaderboardID
        , points: 100
        }
    , android: PG.submitScore
        { leaderboardID: PGConstants.track3LeaderboardID, amount: 100 }
    }
  , { text: "Add 1000 @ lb 3"
    , modProfile: ProfileTransaction $ updateViaTransaction (Proxy :: _ "highScoreTrack3") (max 1000) 1000
    , ios: GC.submitScore
        { leaderboardID: GCContants.track3LeaderboardID
        , points: 1000
        }
    , android: PG.submitScore
        { leaderboardID: PGConstants.track3LeaderboardID, amount: 1000 }
    }
  ]

devAdmin
  :: { platform :: Platform }
  -> Effect Unit
devAdmin opts = customComponent "dev-admin" {} (pure unit) (pure unit) \_ ->
  [ ionHeader (oneOf [ I.Translucent !:= true ])
      [ ionToolbar_
          [ ionButtons (oneOf [ I.Slot !:= "start" ])
              [ ionBackButton (oneOf [ I.DefaultHref !:= "/" ]) []
              ]
          , ionTitle_ [ text_ "Dev Admin" ]
          ]
      ]
  , ionContent (oneOf [ klass_ "ion-padding", I.Fullscren !:= true ])
      [ ionGrid_
          ( chunks <#> \i -> ionRow_ $ toArray i <#> \j -> ionCol_
              [ ionButton
                  ( oneOf
                      [ click_ $ launchAff_ (doBusinessLogic opts.platform j)
                      ]
                  )
                  [ text_ j.text ]
              ]
          )
      ]

  ]
  where
  chunks = chunk 3 businessLogic
