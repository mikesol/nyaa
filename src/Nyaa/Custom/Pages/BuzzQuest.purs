module Nyaa.Custom.Pages.BuzzQuest where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

buzzQuest :: Effect Unit
buzzQuest = questPage
  { name: "buzz-quest"
  , title: "Unlock Buzz!"
  , showFriend: true
  , battleRoute: "/newb-level"
  }