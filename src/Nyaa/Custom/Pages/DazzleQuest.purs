module Nyaa.Custom.Pages.DazzleQuest where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

dazzleQuest :: Effect Unit
dazzleQuest = questPage
  { name: "dazzle-quest"
  , showFriend: true
  }