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
import Effect.Aff (launchAff_)
import Nyaa.Capacitor.Utils (Platform(..))
import Nyaa.Constants.GameCenter as GCContants
import Nyaa.Constants.PlayGames as PGConstants
import Nyaa.GameCenter (ReportableAchievement(..))
import Nyaa.GameCenter as GC
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.BackButton (ionBackButton)
import Nyaa.Ionic.Button (ionButton)
import Nyaa.Ionic.Buttons (ionButtons)
import Nyaa.Ionic.Col (ionCol_)
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent_)
import Nyaa.Ionic.Grid (ionGrid_)
import Nyaa.Ionic.Header (ionHeader)
import Nyaa.Ionic.Row (ionRow_)
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)
import Nyaa.PlayGames as PG
import Nyaa.Util.Chunk (chunk)

stuff
  :: Array
       { android :: Effect (Promise Unit)
       , ios :: Effect (Promise Unit)
       , text :: String
       }
stuff =
  [ { text: "Unlock tutorial"
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
    , ios: GC.submitScore
        { leaderboardID: GCContants.track1LeaderboardID
        , points: 10
        }
    , android: PG.submitScore
        { leaderboardID: PGConstants.track1LeaderboardID, amount: 10 }
    }
  , { text: "Add 100 @ lb 1"
    , ios: GC.submitScore
        { leaderboardID: GCContants.track1LeaderboardID
        , points: 100
        }
    , android: PG.submitScore
        { leaderboardID: PGConstants.track1LeaderboardID, amount: 100 }
    }
  , { text: "Add 1000 @ lb 1"
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
    , ios: GC.submitScore
        { leaderboardID: GCContants.track2LeaderboardID
        , points: 10
        }
    , android: PG.submitScore
        { leaderboardID: PGConstants.track2LeaderboardID, amount: 10 }
    }
  , { text: "Add 100 @ lb 2"
    , ios: GC.submitScore
        { leaderboardID: GCContants.track2LeaderboardID
        , points: 100
        }
    , android: PG.submitScore
        { leaderboardID: PGConstants.track2LeaderboardID, amount: 100 }
    }
  , { text: "Add 1000 @ lb 2"
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
    , ios: GC.submitScore
        { leaderboardID: GCContants.track3LeaderboardID
        , points: 10
        }
    , android: PG.submitScore
        { leaderboardID: PGConstants.track3LeaderboardID, amount: 10 }
    }
  , { text: "Add 100 @ lb 3"
    , ios: GC.submitScore
        { leaderboardID: GCContants.track3LeaderboardID
        , points: 100
        }
    , android: PG.submitScore
        { leaderboardID: PGConstants.track3LeaderboardID, amount: 100 }
    }
  , { text: "Add 1000 @ lb 3"
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
devAdmin opts = customComponent_ "dev-admin" {} \_ ->
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
                      [ click_ $ launchAff_
                          ( if opts.platform == IOS then toAffE j.ios
                            else if opts.platform == Android then toAffE
                              j.android
                            else pure unit
                          )
                      ]
                  )
                  [ text_ j.text ]
              ]
          )
      ]

  ]
  where
  chunks = chunk 3 stuff
