module Nyaa.Custom.Builders.QuestPage where

import Prelude

import Control.Promise (toAffE)
import Data.Either (Either(..))
import Data.Foldable (for_, oneOf)
import Data.Maybe (Maybe(..))
import Data.Nullable (toMaybe)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Deku.Listeners (click_)
import Effect (Effect)
import Effect.Aff (Milliseconds(..), delay, launchAff_, makeAff)
import Effect.Class (liftEffect)
import Effect.Ref as Ref
import Nyaa.Audio (refreshAudioContext)
import Nyaa.Firebase.Firebase (getCurrentUser)
import Nyaa.Ionic.Alert (alert)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.BackButton (ionBackButton)
import Nyaa.Ionic.Button (ionButton)
import Nyaa.Ionic.Buttons (ionButtons)
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent_)
import Nyaa.Ionic.Header (ionHeader)
import Nyaa.Ionic.Loading (dismissLoading, presentLoading)
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)
import Nyaa.Matchmaking (doMatchmaking)
import Nyaa.Types.BattleRoute (BattleRoute(..), battleRouteToPath, battleRouteToRoomNumber)
import Ocarina.WebAPI (AudioContext)
import Routing.Hash (setHash)

questPage
  :: { name :: String
     , title :: String
     , showFriend :: Boolean
     , battleRoute :: BattleRoute
     , audioContextRef :: Ref.Ref AudioContext
     }
  -> Effect Unit
questPage i = customComponent_ i.name {} \_ -> do
  let
    playAction name channel isHost = do
      loading2 <- toAffE $ presentLoading
        ( "Prepare to battle "
            <> name
            <> "!"
        )
      delay (Milliseconds 1200.0)
      liftEffect do
        setHash
          ( ( battleRouteToPath
                i.battleRoute
            ) <> "/" <> channel
              <> "/"
              <> isHost
          )
      toAffE $ dismissLoading loading2
    startBattle = do
      refreshAudioContext i.audioContextRef
      case i.battleRoute of
        TutorialLevel -> setHash
          (battleRouteToPath i.battleRoute)
        _ -> launchAff_ do --matchmaking
          loading <- toAffE $ presentLoading
            "Finding someone to battle"
          makeAff \cb -> do
            doMatchmaking
              (battleRouteToRoomNumber i.battleRoute)
              ( do
                  cb (Right unit)
                  launchAff_ do
                    toAffE $ dismissLoading loading
                    alert "Sorry!" Nothing
                      ( Just
                          "We couldn't find a good match."
                      )
                      [ { text: "Play a bot"
                        , handler: launchAff_ do
                            playAction
                              "our highly-intelligent bot"
                              "bot"
                              "true"
                        }
                      , { text: "Try again", handler: startBattle }
                      ]
              )
              ( \{ player1
                 , player2
                 , player1Name
                 , player2Name
                 } -> do
                  me <- getCurrentUser
                  for_ (toMaybe me) \{ uid } -> launchAff_
                    do
                      toAffE $ dismissLoading loading
                      playAction
                        (if player1 == uid then player2Name else player1Name)
                        (player1 <> player2)
                        (if player1 == uid then "true" else "false")
              )
            pure mempty
  [ ionHeader
      ( oneOf
          [ I.Translucent !:= true
          , click_ do
              refreshAudioContext i.audioContextRef
              setHash
                ( ( battleRouteToPath
                      i.battleRoute
                  ) <> "/bot/true"
                )
          ]
      )
      [ ionToolbar_
          [ ionButtons (oneOf [ I.Slot !:= "start" ])
              [ ionBackButton (oneOf [ I.DefaultHref !:= "/" ]) []
              ]
          , ionTitle_ [ text_ i.title ]
          ]
      ]
  , ionContent (oneOf [ I.Fullscren !:= true ])
      [ D.div
          ( oneOf
              [ klass_
                  "bg-beach bg-no-repeat bg-cover bg-center w-full h-full grid grid-cols-7 grid-rows-3"
              ]
          )
          [ D.div (klass_ "row-start-2 col-start-2 row-span-1 col-span-3")
              ( [ ionButton
                    ( oneOf
                        [ click_ startBattle ]
                    )
                    [ text_ "Start the battle"
                    ]
                ]
              -- for now we hide showing friends
              --   <> guard i.showFriend
              --     [ ionButton_ [ text_ "Battle a friend" ] ]
              )
          ]
      ]
  ]
