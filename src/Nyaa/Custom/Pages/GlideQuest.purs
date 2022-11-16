module Nyaa.Custom.Pages.GlideQuest where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

glideQuest :: Effect Unit
glideQuest = questPage
  { name: "glide-quest"
  , title: "Unlock Glide!"
  , showFriend: true
  , battleRoute: "/newb-level"
  }