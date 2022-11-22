module Nyaa.Types.Quests where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)

data Quests
  = Hypersynthetic
  | Equalize
  | Camera
  | Glide
  | Back
  | Lvl99
  | Rotate
  | Hide
  | Dazzle
  | ShowMeHow
  | Audio
  | Amplify

derive instance Generic Quests _
derive instance Eq Quests
derive instance Ord Quests
instance Show Quests where
  show = genericShow