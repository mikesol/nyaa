module Nyaa.GameCenter where

import Prelude

import Control.Promise (Promise)
import Data.Nullable (Nullable)
import Effect (Effect)

newtype Achievement = Achievement
  { identifier :: String
  , isCompleted :: Boolean
  , lastReportedDate :: String
  , percentComplete :: Number
  , showsCompletionBanner :: Boolean
  }

newtype LeaderboardLocalPlayer = LeaderboardLocalPlayer
  { rank :: Nullable Int
  , score :: Nullable Int
  , formattedScore :: Nullable String
  , date :: Nullable String
  }

newtype LeaderboardEntry = LeaderboardEntry
  { rank :: Nullable Int
  , score :: Nullable Int
  , formattedScore :: Nullable String
  , date :: Nullable String
  , displayName :: Nullable String
  , alias :: Nullable String
  , gamePlayerID :: String
  , teamPlayerID :: String
  -- base 64 encoded
  , avatar :: Nullable String
  }

newtype ReportableAchievement = ReportableAchievement
  { achievementID :: String, percentComplete :: Number }

foreign import showAccessPoint
  :: { location :: String, showHighlights :: Boolean } -> Effect (Promise Unit)

foreign import hideAccessPoint :: Effect (Promise Unit)
foreign import showGameCenter :: { state :: String } -> Effect (Promise Unit)
foreign import getLeaderboard
  :: { leaderboardID :: String }
  -> Effect
       ( Promise
           { localPlayer :: LeaderboardLocalPlayer
           , entries :: Array LeaderboardEntry
           }
       )

foreign import submitScore
  :: { leaderboardID :: String, points :: Int } -> Effect (Promise Unit)

foreign import getAchievements
  :: Effect (Promise { achievements :: Array Achievement })

foreign import reportAchievements
  :: { achievements :: Array ReportableAchievement
     }
  -> Effect (Promise {})