module Nyaa.Custom.Pages.ShowMeHowQuest where

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

showMeHowQuest :: Effect Unit
showMeHowQuest = questPage
  { name: "showmehow-quest"
  , title: "Unlock Show Me How!"
  , showFriend: true
  , battleRoute: "/pro-level"
  }