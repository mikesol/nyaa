module Nyaa.Custom.Pages.LVL99Quest where

import Effect.Ref as Ref
import Ocarina.WebAPI (AudioContext)

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.BattleRoute (BattleRoute(..))

lvl99Quest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
lvl99Quest { audioContextRef } = questPage
  { name: "lvlnn-quest"
  , title: "Unlock Show Me How!"
  , showFriend: true
  , audioContextRef
  , battleRoute: DeityLevel
  }