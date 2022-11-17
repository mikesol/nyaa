module Nyaa.Custom.Builders.Game where

import Prelude

import Data.Foldable (oneOf)
import Data.Maybe (Maybe(..))
import Data.Monoid (guard)
import Data.Newtype (unwrap)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_, id_)
import Deku.Control (switcher, text_)
import Deku.Core (Nut)
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Listeners (click)
import Effect (Effect)
import Effect.Aff (Milliseconds, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Ref as Ref
import FRP.Event (Event, EventIO, create, subscribe)
import Nyaa.Constants.Effects (EffectTiming(..), effectTimings)
import Nyaa.CoordinatedNow (coordinatedNow)
import Nyaa.Firebase.Firebase (Profile(..))
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent)
import Nyaa.Some (get)
import Nyaa.Util.RandomId (makeId)
import Ocarina.Interpret (decodeAudioDataFromUri)
import Ocarina.WebAPI (AudioContext, BrowserAudioBuffer)
import Type.Proxy (Proxy(..))
import Web.DOM.Document (toNonElementParentNode)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (HTMLCanvasElement, window)
import Web.HTML.HTMLCanvasElement as HTMLCanvasElement
import Web.HTML.HTMLDocument (toDocument)
import Web.HTML.Window (document)

godMode ∷ Boolean
godMode = false

newtype FxData = FxData
  { fx :: Fx, startTime :: Number, duration :: Number }

type FxPusher = FxData -> Effect Unit

foreign import currentTime :: AudioContext -> Effect Number

fxButton'
  :: FxPusher
  -> AudioContext
  -> Event Number
  -> { icon :: String
     , color :: String
     , fx :: Fx
     , active :: Maybe Boolean
     , timing :: EffectTiming
     }
  -> Nut
fxButton' push ctx eni i = do
  let isActive = (i.active == Just true) || godMode
  D.button
    ( oneOf
        ( guard isActive
            [ click $ eni <#> \startsAt -> do
                ctm <- currentTime ctx
                push
                  ( FxData
                      { fx: i.fx
                      , startTime: ctm - startsAt
                      , duration: (unwrap i.timing).duration
                      }
                  )
            ] <>
            [ D.Disabled !:= (if isActive then "false" else "true")
            , klass_
                $ (if isActive then i.color else "bg-white") <>
                    ( " font-semibold py-2 px-4 border border-gray-400 rounded shadow ml-2 mt-2"
                        <>
                          ( if isActive then ""
                            else " opacity-50 cursor-not-allowed"
                          )
                    )
            ]
        )
    )
    [ text_ (if isActive then i.icon else "?") ]

foreign import startGame
  :: HTMLCanvasElement
  -> ((FxData -> Effect Unit) -> Effect (Effect Unit))
  -> (Number -> Effect Unit)
  -> (FxData -> Effect Unit)
  -> (FxData -> Effect Unit)
  -> String
  -> String
  -> Boolean
  -> AudioContext
  -> BrowserAudioBuffer
  -> Effect { time :: Milliseconds, diff :: Number, pdiff :: Number }
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
     , audioContext :: AudioContext
     , audioUri :: String
     , profile :: Event Profile
     , fxEvent :: EventIO FxData
     }
  -> Effect Unit
game { name, audioContext, audioUri, fxEvent, profile } = do
  myEffect <- create
  theirEffect <- create
  currentTimeEvent <- create
  let setFx = fxEvent.push
  let fx = fxEvent.event
  killRef <- Ref.new (pure unit)
  let
    gameStart { roomId, isHost } = launchAff_ do
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
              canvas
              (subscribe fx)
              (currentTimeEvent.push)
              myEffect.push
              theirEffect.push
              "nyaa!"
              roomId
              (isHost == "true")
              audioContext
              audioBuffer
              n.now
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
          let fxButton = fxButton' setFx audioContext currentTimeEvent.event
          ionContent (oneOf [ I.Fullscren !:= true ])
            [ D.canvas
                ( oneOf
                    [ klass_ "absolute w-full h-full", id_ (name <> "-canvas") ]
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
                            ]
                        )
                        [ text_ "0000000"
                        ]
                    , D.span
                        ( oneOf
                            [ id_ "score-enemy"
                            , klass_ "text-green-500 text-2xl font-mono"
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
            , flip switcher profile \(Profile p) -> D.div (klass_ "absolute")
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
                        [ id_ "time-remaining"
                        , klass_ "text-blue-500 text-xl ml-2 mt-1 font-mono"
                        ]
                    )
                    [ text_ "15"
                    ]
                , D.span
                    ( oneOf
                        [ id_ "time-remaining"
                        , klass_ "text-green-500 text-xl ml-2 mt-1 font-mono"
                        ]
                    )
                    [ text_ "15"
                    ]
                ]
            ]
      ]
