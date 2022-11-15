module Nyaa.Custom.Pages.CrushQuest where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

crushQuest :: Effect Unit
crushQuest = questPage
  { name: "crush-quest"
  , title: "Unlock Crush!"
  , showFriend: true
  , battleRoute: "/deity-level"
  }