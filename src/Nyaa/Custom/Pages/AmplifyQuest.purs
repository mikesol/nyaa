module Nyaa.Custom.Pages.AmplifyQuest where

import Effect.Ref as Ref
import Ocarina.WebAPI (AudioContext)

import Prelude

import Effect (Effect)
import Nyaa.Custom.Builders.QuestPage (questPage)

amplifyQuest :: { audioContextRef :: Ref.Ref AudioContext } -> Effect Unit
amplifyQuest { audioContextRef } = questPage
  { name: "amplify-quest"
  , title: "Unlock Amplify!"
  , showFriend: true
  , audioContextRef
  , battleRoute: "/deity-level"
  }