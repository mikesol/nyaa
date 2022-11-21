module Nyaa.Types.BattleRoute where

data BattleRoute = TutorialLevel | NewbLevel | ProLevel | DeityLevel

battleRouteToPath :: BattleRoute -> String
battleRouteToPath = case _ of
  TutorialLevel -> "/tutorial-level"
  NewbLevel -> "/newb-level"
  ProLevel -> "/pro-level"
  DeityLevel -> "/deity-level"

battleRouteToRoomNumber :: BattleRoute -> Int
battleRouteToRoomNumber = case _ of
  TutorialLevel -> 0
  NewbLevel -> 1
  ProLevel -> 2
  DeityLevel -> 3