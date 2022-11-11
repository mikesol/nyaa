module Nyaa.Custom.Pages.AmplifyQuest where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

amplifyQuest :: Effect Unit
amplifyQuest = questPage
  { name: "amplify-quest"
  , showFriend: true
  , battleRoute: "/deity-level"
  }