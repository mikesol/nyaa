module Nyaa.Custom.Pages.GlideQuest where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

glideQuest :: Effect Unit
glideQuest = questPage
  { name: "glide-quest"
  , showFriend: true
  , battleRoute: "/newb-level"
  }