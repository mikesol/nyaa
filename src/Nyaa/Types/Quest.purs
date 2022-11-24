module Nyaa.Types.Quest where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)

data Quest
  = Hypersynthetic
  | Equalize
  | Camera
  | Glide
  | Back
  | Lvl99
  | BeatHypersynthetic
  | Rotate
  | Hide
  | Dazzle
  | ShowMeHow
  | BeatLvl99
  | Audio
  | Amplify
  | YouWon

derive instance Generic Quest _
derive instance Eq Quest
derive instance Ord Quest
instance Show Quest where
  show = genericShow

questToPath :: Quest -> String
questToPath = case _ of
  Hypersynthetic -> "/tutorial-level"
  Equalize -> "/equalize-level"
  Camera -> "/camera-level"
  Glide -> "/glide-level"
  Back -> "/back-level"
  Lvl99 -> "/lvlnn-level"
  BeatHypersynthetic -> "/hypersyntheticdone-level"
  Rotate -> "/rotate-level"
  Hide -> "/hide-level"
  Dazzle -> "/dazzle-level"
  BeatLvl99 -> "/lvlnndone-level"
  ShowMeHow -> "/showmehow-level"
  Audio -> "/crush-level"
  Amplify -> "/amplify-level"
  YouWon -> "/youwon-level"

questToRoomNumber :: Quest -> Int
questToRoomNumber = case _ of
  Hypersynthetic -> 0
  Equalize -> 1
  Camera -> 1
  Glide -> 1
  Back -> 1
  Lvl99 -> 1
  BeatHypersynthetic -> 1
  Rotate -> 2
  Hide -> 2
  Dazzle -> 2
  ShowMeHow -> 2
  BeatLvl99 -> 2
  Audio -> 3
  Amplify -> 3
  YouWon -> 3