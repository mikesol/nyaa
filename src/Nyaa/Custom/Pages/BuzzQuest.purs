module Nyaa.Custom.Pages.BuzzQuest where

import Effect.Ref as Ref
import Ocarina.WebAPI (AudioContext)

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.BattleRoute (BattleRoute(..))

buzzQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
buzzQuest { audioContextRef } = questPage
  { name: "buzz-quest"
  , title: "Unlock Buzz!"
  , showFriend: true
  , audioContextRef
  , battleRoute: NewbLevel
  }