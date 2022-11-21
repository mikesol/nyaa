module Nyaa.Custom.Pages.GlideQuest where

import Effect.Ref as Ref
import Ocarina.WebAPI (AudioContext)

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)
import Nyaa.Types.BattleRoute (BattleRoute(..))

glideQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
glideQuest { audioContextRef } = questPage
  { name: "glide-quest"
  , title: "Unlock Glide!"
  , showFriend: true
  , audioContextRef
  , battleRoute: NewbLevel
  }