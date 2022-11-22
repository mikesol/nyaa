module Nyaa.Types.Quests where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)

data Quests
  = Equalize
  | Camera
  | Glide
  | Back
  | Rotate
  | Hide
  | Dazzle
  | Audio
  | Amplify

derive instance Generic Quests _
derive instance Eq Quests
derive instance Ord Quests
instance Show Quests where
  show = genericShow