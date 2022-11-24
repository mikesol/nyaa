module Nyaa.Custom.Builders.Game where

import Prelude

import Control.Alt ((<|>))
import Control.Plus (empty)
import Control.Promise (Promise, fromAff)
import Data.Foldable (oneOf)
import Data.Int (floor)
import Data.Maybe (Maybe(..))
import Data.Monoid (guard)
import Data.Newtype (unwrap)
import Data.Tuple (Tuple(..))
import Deku.Attribute ((!:=), (:=))
import Deku.Attributes (id_, klass, klass_)
import Deku.Control (switcher, text, text_)
import Deku.Core (Nut)
import Deku.DOM as D
import Deku.Listeners (click, click_)
import Effect (Effect)
import Effect.Aff (Milliseconds, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO, create, subscribe)
import Nyaa.Audio (refreshAudioContext)
import Nyaa.Capacitor.Utils (Platform(..), getPlatform)
import Nyaa.Charts.NoteInfo (NoteInfo)
import Nyaa.Constants.Effects (EffectTiming, effectTimings)
import Nyaa.Constants.PlayGames as PGConstants
import Nyaa.CoordinatedNow (coordinatedNow)
import Nyaa.FRP.Dedup (dedup)
import Nyaa.Firebase.Firebase (Profile(..))
import Nyaa.GameCenter as GC
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent)
import Nyaa.PlayGames as PG
import Nyaa.Some (get, some)
import Nyaa.Types.Quest (Quest, questToRoomNumber)
import Nyaa.Util.Countdown (countdown)
import Ocarina.Interpret (decodeAudioDataFromUri)
import Ocarina.WebAPI (AudioContext, BrowserAudioBuffer)
import Type.Proxy (Proxy(..))
import Web.DOM.Document (toNonElementParentNode)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (HTMLCanvasElement, window)
import Web.HTML.HTMLCanvasElement as HTMLCanvasElement
import Web.HTML.HTMLDocument (toDocument)
import Web.HTML.Window (document)

data ActivatedStates = PreCountdown | InCountdown | PostCountdown

godMode ∷ Boolean
godMode = false

newtype FxData = FxData
  { fx :: Fx, startTime :: Number, duration :: Number }

type FxPusher = FxData -> Effect Unit

foreign import currentTime :: AudioContext -> Effect Number

fxButton'
  :: FxPusher
  -> (Unit -> Effect Unit)
  -> Event ActivatedStates
  -> Ref.Ref AudioContext
  -> Event Number
  -> { icon :: String
     , color :: String
     , fx :: Fx
     , active :: Maybe Boolean
     , timing :: EffectTiming
     }
  -> Nut
fxButton' push activated aStateEv ctxRef eni i = do
  let isActive = (i.active == Just true) || godMode
  let
    activeEvent = pure isActive <|>
      ( aStateEv <#> case _ of
          PostCountdown -> true
          _ -> false
      )

  D.button
    ( oneOf
        ( [ click $ (Tuple <$> activeEvent <*> eni) <#>
              \(Tuple active startsAt) -> guard active do
                log "sending effect"
                activated unit
                ctx <- Ref.read ctxRef
                ctm <- currentTime ctx
                push
                  ( FxData
                      { fx: i.fx
                      , startTime: ctm - startsAt
                      , duration: (unwrap i.timing).duration
                      }
                  )
          , activeEvent <#> \ase -> D.Disabled :=
              (if ase then "false" else "true")
          , klass $
              ( pure PostCountdown <|> aStateEv <#> case _ of
                  PostCountdown -> true
                  _ -> false
              ) <#> \stEv ->
                (if isActive then i.color else "bg-white") <>
                  ( " font-semibold py-2 px-4 border border-gray-400 rounded shadow ml-2 mt-2"
                      <>
                        ( if isActive && stEv then ""
                          else " opacity-50 cursor-not-allowed"
                        )
                  )
          ]
        )
    )
    [ text_ (if isActive then i.icon else "?") ]

foreign import startGame
  :: { canvas :: HTMLCanvasElement
     , subToEffects :: ((FxData -> Effect Unit) -> Effect (Effect Unit))
     , pushBeginTime :: (Number -> Effect Unit)
     , myEffect :: (FxData -> Effect Unit)
     , theirEffect :: (FxData -> Effect Unit)
     , userId :: String
     , roomId :: String
     , isHost :: Boolean
     , audioContext :: AudioContext
     , audioBuffer :: BrowserAudioBuffer
     , scoreToWin :: Int
     , getTime ::
         Effect { time :: Milliseconds, diff :: Number, pdiff :: Number }
     , noteInfo :: Array NoteInfo
     , roomNumber :: Int
     , successPath :: String
     , failurePath :: String
     , successCb :: Int -> Effect (Promise Unit)
     , failureCb :: Int -> Effect (Promise Unit)
     , showLeaderboard :: Effect (Promise Unit)
     }
  -> Effect { start :: Effect Unit, kill :: Effect Unit }

newtype Fx = Fx String

flatFx :: Fx
flatFx = Fx "equalize"

buzzFx :: Fx
buzzFx = Fx "camera"

glideFx :: Fx
glideFx = Fx "glide"

backFx :: Fx
backFx = Fx "compress"

rotateFx :: Fx
rotateFx = Fx "rotate"

hideFx :: Fx
hideFx = Fx "hide"

dazzleFx :: Fx
dazzleFx = Fx "dazzle"

audioFx :: Fx
audioFx = Fx "audio"

amplifyFx :: Fx
amplifyFx = Fx "amplify"

game
  :: { name :: String
     , audioContextRef :: Ref.Ref AudioContext
     , audioUri :: String
     , backgroundName :: String
     , quest :: Quest
     , scoreToWin :: Int
     , profile :: Event Profile
     , fxEvent :: EventIO FxData
     , chart :: Array NoteInfo
     , successPath :: String
     , failurePath :: String
     , successCb :: Int -> Effect (Promise Unit)
     , failureCb :: Int -> Effect (Promise Unit)
     }
  -> Effect Unit
game
  { name
  , audioContextRef
  , audioUri
  , backgroundName
  , scoreToWin
  , fxEvent
  , profile
  , chart
  , quest
  , successPath
  , failurePath
  , successCb
  , failureCb
  } =
  do
    myCountdownRef <- Ref.new (pure unit)
    theirCountdownRef <- Ref.new (pure unit)
    myCountdownNumber <- create
    theirCountdownNumber <- create
    myCountdownIsOn <- create
    theirCountdownIsOn <- create
    myEffect <- create
    theirEffect <- create
    activatedEffect <- create
    let
      myEffectPuhser = \n@(FxData fxData) -> do
        myCountdown <- countdown 1000.0 (floor fxData.duration)
          ( \i -> do
              myCountdownNumber.push i
              myCountdownIsOn.push true
          )
          (myCountdownIsOn.push false)
        Ref.write myCountdown myCountdownRef
        myEffect.push n
    let
      theirEffectPusher = \n@(FxData fxData) -> do
        theirCountdown <- countdown 1000.0 (floor fxData.duration)
          ( \i -> do
              theirCountdownNumber.push i
              theirCountdownIsOn.push true
          )
          (theirCountdownIsOn.push false)
        Ref.write theirCountdown theirCountdownRef
        theirEffect.push n
    currentTimeEvent <- create
    let setFx = fxEvent.push
    let fx = fxEvent.event
    killRef <- Ref.new (pure unit)
    let
      gameStart { roomId, isHost } = launchAff_ do
        audioContext <- liftEffect $ Ref.read audioContextRef
        audioBuffer <- decodeAudioDataFromUri audioContext audioUri
        liftEffect do
          n <- coordinatedNow
          t <- n.now
          log $ "[Game] Initial timestamp is set at " <> show (unwrap t.time)
          w <- window
          d <- document w
          c <- getElementById (name <> "-canvas") $ toNonElementParentNode $
            toDocument d
          case c >>= HTMLCanvasElement.fromElement of
            Just canvas -> do
              controls <- startGame
                { canvas
                , subToEffects: subscribe fx
                , pushBeginTime: currentTimeEvent.push
                , myEffect: myEffectPuhser
                , theirEffect: theirEffectPusher
                , userId: "nyaa!"
                , roomId
                , isHost: isHost == "true"
                , audioContext
                , audioBuffer
                , scoreToWin
                , getTime: n.now
                , noteInfo: chart
                , roomNumber: questToRoomNumber quest
                , successPath
                , failurePath
                , successCb
                , failureCb
                , showLeaderboard: do
                    platform <- getPlatform
                    case platform of
                      IOS -> GC.showGameCenter { state: "leaderboards" }
                      Android -> PG.showLeaderboard
                        { leaderboardID:
                            -- ugh, hacky as it's relying on numbers, make more solid!
                            case questToRoomNumber quest of
                              1 -> PGConstants.track1LeaderboardID
                              2 -> PGConstants.track2LeaderboardID
                              _ -> PGConstants.track3LeaderboardID
                        }
                      Web -> fromAff $ pure unit
                }
              controls.start
              Ref.write (controls.kill *> n.cancelNow) killRef
            Nothing ->
              pure unit
      gameEnd _ = do
        v <- Ref.read killRef
        v
    customComponent name { roomId: "debug-room", isHost: "false" } gameStart
      gameEnd
      \_ ->
        [ Deku.do
            let
              activatedStateEvent =
                ( map
                    (if _ then InCountdown else PostCountdown)
                    $ dedup
                        (myCountdownIsOn.event <|> pure false)
                ) <|> (activatedEffect.event $> PreCountdown)
              fxButton = fxButton' setFx activatedEffect.push
                activatedStateEvent
                audioContextRef
                currentTimeEvent.event
            ionContent (oneOf [ I.Fullscren !:= true ])
              [ D.div
                  (oneOf [ klass_ $ "absolute w-full h-full bg-no-repeat bg-cover bg-center " <> backgroundName ])
                  [
                  ]
              , D.canvas
                  ( oneOf
                      [ klass_ "absolute w-full h-full backdrop-blur"
                      , id_ (name <> "-canvas")
                      ]
                  )
                  [
                  ]
              , D.div
                  ( oneOf
                      [ klass_
                          "absolute w-full h-full grid grid-cols-3 grid-rows-3"
                      ]
                  )
                  [ D.div
                      ( oneOf
                          [ klass_
                              "flex flex-col col-start-3 justify-self-end m-4"
                          ]
                      )
                      [ D.span
                          ( oneOf
                              [ id_ "score-player"
                              , klass_ "text-blue-500 text-2xl font-mono"
                              , click_ $ refreshAudioContext audioContextRef
                              ]
                          )
                          [ text_ "0000000"
                          ]
                      , D.span
                          ( oneOf
                              [ id_ "score-enemy"
                              , klass_ "text-green-500 text-2xl font-mono"
                              , click_ $ refreshAudioContext audioContextRef
                              ]
                          )
                          [ text_ "0000000"
                          ]
                      ]
                  , D.span
                      ( oneOf
                          [ id_ "judgment"
                          , klass_
                              "text-white row-start-2 col-start-2 justify-self-center self-center text-2xl"
                          ]
                      )
                      [ text_ "..."
                      ]
                  ]
              , flip switcher
                  ( profile <|>
                      (if godMode then (pure $ Profile (some {})) else empty)
                  )
                  \(Profile p) -> D.div (klass_ "absolute")
                    [ fxButton
                        { active: get (Proxy :: _ "flat") p
                        , icon: "😬"
                        , fx: flatFx
                        , color: "bg-red-200"
                        , timing: effectTimings.flat
                        } --
                    , fxButton
                        { active: get (Proxy :: _ "buzz") p
                        , icon: "🎥"
                        , fx: buzzFx
                        , color: "bg-orange-100"
                        , timing: effectTimings.buzz
                        } --
                    , fxButton
                        { active: get (Proxy :: _ "glide") p
                        , icon: "🚀"
                        , fx: glideFx
                        , color: "bg-amber-100"
                        , timing: effectTimings.glide
                        } --
                    , fxButton
                        { active: get (Proxy :: _ "back") p
                        , icon: "☝️"
                        , fx: backFx
                        , color: "bg-lime-100"
                        , timing: effectTimings.back
                        } --
                    , fxButton
                        { active: get (Proxy :: _ "rotate") p
                        , icon: "🌀"
                        , fx: rotateFx
                        , color: "bg-purple-100"
                        , timing: effectTimings.rotate
                        } --
                    , fxButton
                        { active: get (Proxy :: _ "hide") p
                        , icon: "🙈"
                        , fx: hideFx
                        , color: "bg-emerald-100"
                        , timing: effectTimings.hide
                        } --
                    , fxButton
                        { active: get (Proxy :: _ "dazzle") p
                        , icon: "✨"
                        , fx: dazzleFx
                        , color: "bg-indigo-300"
                        , timing: effectTimings.dazzle
                        } --
                    , fxButton
                        { active: get (Proxy :: _ "crush") p
                        , icon: "🤘"
                        , fx: audioFx
                        , color: "bg-rose-200"
                        , timing: effectTimings.crush
                        } --
                    , fxButton
                        { active: get (Proxy :: _ "amplify") p
                        , icon: "📣"
                        , fx: amplifyFx
                        , color: "bg-neutral-200"
                        , timing: effectTimings.amplify
                        } --
                    , D.span
                        ( oneOf
                            [ id_ "my-time-remaining"
                            , klass
                                ( activatedStateEvent
                                    <#>
                                      \effectState ->
                                        ( case effectState of
                                            PreCountdown -> "bg-blue-500 "
                                            _ -> ""
                                        )
                                          <>
                                            "text-blue-500 text-xl ml-2 mt-1 font-mono"
                                          <>
                                            ( case effectState of
                                                PostCountdown -> " invisible"
                                                _ -> ""
                                            )

                                )
                            ]
                        )
                        [ text (pure "0" <|> show <$> myCountdownNumber.event)
                        ]
                    , D.span
                        ( oneOf
                            [ id_ "their-time-remaining"
                            , klass
                                ( dedup
                                    (theirCountdownIsOn.event <|> pure false)
                                    <#> \isOn ->
                                      "text-green-500 text-xl ml-2 mt-1 font-mono"
                                        <>
                                          ( if not isOn then " invisible"
                                            else ""
                                          )
                                )
                            ]
                        )
                        [ text (show <$> theirCountdownNumber.event)
                        ]
                    ]
              ]
        ]
