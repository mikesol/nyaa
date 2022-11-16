module Nyaa.Custom.Pages.LVL99Quest where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

lvl99Quest :: Effect Unit
lvl99Quest = questPage
  { name: "lvlnn-quest"
  , title: "Unlock Show Me How!"
  , showFriend: true
  , battleRoute: "/deity-level"
  }