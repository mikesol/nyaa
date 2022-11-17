module Nyaa.Custom.Builders.Game where

import Prelude

import Data.Foldable (oneOf)
import Data.JSDate (getTime, now)
import Data.Maybe (Maybe(..))
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_, id_)
import Deku.Control (text_)
import Deku.Core (Nut)
import Deku.DOM as D
import Deku.Listeners (click_)
import Effect (Effect)
import Effect.Aff (Milliseconds(..), launchAff_)
import Effect.Class (liftEffect)
import Effect.Ref as Ref
import FRP.Event (EventIO, subscribe)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent)
import Ocarina.Interpret (decodeAudioDataFromUri)
import Ocarina.WebAPI (AudioContext, BrowserAudioBuffer)
import Web.DOM.Document (toNonElementParentNode)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (HTMLCanvasElement, window)
import Web.HTML.HTMLCanvasElement as HTMLCanvasElement
import Web.HTML.HTMLDocument (toDocument)
import Web.HTML.Window (document)

newtype FxData = FxData { fx :: Fx, startTime :: Milliseconds }
type FxPusher = FxData -> Effect Unit
type TimeGetter = Effect Milliseconds

fxButton'
  :: TimeGetter
  -> FxPusher
  -> { icon :: String, color :: String, fx :: Fx }
  -> Nut
fxButton' nowIs push i = D.button
  ( oneOf
      [ click_ do
          startTime <- nowIs
          push (FxData { fx: i.fx, startTime })
      , klass_
          $ i.color <>
              " font-semibold py-2 px-4 border border-gray-400 rounded shadow ml-2 mt-2"
      ]
  )
  [ text_ i.icon ]

foreign import startGame
  :: HTMLCanvasElement
  -> ((FxData -> Effect Unit) -> Effect (Effect Unit))
  -> String
  -> AudioContext
  -> BrowserAudioBuffer
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
     , fxEvent :: EventIO FxData
     }
  -> Effect Unit
game { name, audioContext, audioUri, fxEvent } = do
  let setFx = fxEvent.push
  let fx = fxEvent.event
  killRef <- Ref.new (pure unit)
  let
    gameStart = launchAff_ do
      audioBuffer <- decodeAudioDataFromUri audioContext audioUri
      liftEffect do
        w <- window
        d <- document w
        c <- getElementById (name <> "-canvas") $ toNonElementParentNode $
          toDocument d
        case c >>= HTMLCanvasElement.fromElement of
          Just canvas -> do
            controls <- startGame canvas (subscribe fx) "nyaa!" audioContext audioBuffer
            controls.start
            Ref.write controls.kill killRef
          Nothing ->
            pure unit
    gameEnd = do
      v <- Ref.read killRef
      v
  customComponent name {} gameStart gameEnd \_ ->
    [ do
        let fxButton = fxButton' (getTime >>> Milliseconds <$> now) setFx
        ionContent (oneOf [ I.Fullscren !:= true ])
          [ D.canvas
              ( oneOf
                  [ klass_ "absolute w-full h-full", id_ (name <> "-canvas") ]
              )
              [
              ]
          , D.div
              ( oneOf
                  [ klass_ "absolute w-full h-full grid grid-cols-3 grid-rows-3"
                  ]
              )
              [ D.div
                  ( oneOf
                      [ klass_ "flex flex-col col-start-3 justify-self-end m-4"
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
          , D.div (klass_ "absolute")
              [ fxButton { icon: "😬", fx: flatFx, color: "bg-red-200" } --
              , fxButton { icon: "🎥", fx: buzzFx, color: "bg-orange-100" } --
              , fxButton { icon: "🚀", fx: glideFx, color: "bg-amber-100" } --
              , fxButton { icon: "☝️", fx: backFx, color: "bg-lime-100" } --
              , fxButton { icon: "🌀", fx: rotateFx, color: "bg-purple-100" } --
              , fxButton { icon: "🙈", fx: hideFx, color: "bg-emerald-100" } --
              , fxButton { icon: "✨", fx: dazzleFx, color: "bg-indigo-300" } --
              , fxButton { icon: "🤘", fx: audioFx, color: "bg-rose-200" } --
              , fxButton { icon: "📣", fx: amplifyFx, color: "bg-neutral-200" } --
              , D.span
                  ( oneOf
                      [ id_ "time-remaining"
                      , klass_ "text-pink-500 text-xl ml-2 mt-1 font-mono"
                      ]
                  )
                  [ text_ "15"
                  ]
              ]
          ]
    ]
