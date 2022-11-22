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
  | Rotate
  | Hide
  | Dazzle
  | ShowMeHow
  | Audio
  | Amplify

derive instance Generic Quest _
derive instance Eq Quest
derive instance Ord Quest
instance Show Quest where
  show = genericShow