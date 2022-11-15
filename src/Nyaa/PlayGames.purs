module Nyaa.PlayGames where

import Prelude

import Control.Promise (Promise)
import Data.Nullable (Nullable)
import Effect (Effect)

newtype Achievement = Achievement
  { achievementId :: String
  , xpValue :: Int
  , type :: Int
  , currentSteps :: Nullable Int
  , formattedCurrentSteps :: Nullable String
  , description :: String
  , totalSteps :: Nullable Int
  , formattedTotalSteps :: Nullable String
  , lastUpdatedTimestamp :: String
  , name :: String
  , state :: Int
  }

foreign import submitScore
  :: { leaderboardID :: String, amount :: Int } -> Effect (Promise Unit)

foreign import showLeaderboard
  :: { leaderboardID :: String } -> Effect (Promise Unit)

foreign import unlockAchievement
  :: { achievementID :: String } -> Effect (Promise Unit)

foreign import incrementAchievement
  :: { achievementID :: String, amount :: Int } -> Effect (Promise Unit)

foreign import getAchievements
  :: Effect (Promise { achievements :: Array Achievement })

foreign import showAchievements :: Effect (Promise Unit)