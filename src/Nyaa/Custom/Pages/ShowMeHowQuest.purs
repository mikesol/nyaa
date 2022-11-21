module Nyaa.Custom.Pages.ShowMeHowQuest where

import Effect.Ref as Ref
import Ocarina.WebAPI (AudioContext)

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.BattleRoute (BattleRoute(..))

showMeHowQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
showMeHowQuest { audioContextRef } = questPage
  { name: "showmehow-quest"
  , title: "Unlock Show Me How!"
  , showFriend: true
  , audioContextRef
  , battleRoute: ProLevel
  }