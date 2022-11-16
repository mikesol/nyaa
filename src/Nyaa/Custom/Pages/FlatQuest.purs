module Nyaa.Custom.Pages.FlatQuest where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

flatQuest :: Effect Unit
flatQuest = questPage
  { name: "flat-quest"
  , title: "Unlock Flat!"
  , showFriend: true
  , battleRoute: "/newb-level"
  }