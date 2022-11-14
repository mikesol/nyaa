module Nyaa.Custom.Builders.Game where

import Prelude

import Data.Foldable (oneOf)
import Data.Maybe (Maybe(..))
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_, id_)
import Deku.Control (text_)
import Deku.DOM as D
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Ref as Ref
import Nyaa.Components.UpperLeftBackButton (upperLeftBackButton)
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

foreign import startGame
  :: HTMLCanvasElement
  -> String
  -> AudioContext
  -> BrowserAudioBuffer
  -> Effect { start :: Effect Unit, kill :: Effect Unit }

game
  :: { name :: String
     , audioContext :: AudioContext
     , audioUri :: String
     }
  -> Effect Unit
game { name, audioContext, audioUri } = do
  killRef <- Ref.new (pure unit)
  let
    gameStart = launchAff_ do
      audioBuffer <- decodeAudioDataFromUri audioContext audioUri
      liftEffect do
        w <- window
        d <- document w
        c <- getElementById (name <> "-canvas") $ toNonElementParentNode $ toDocument d
        case c >>= HTMLCanvasElement.fromElement of
          Just canvas -> do
            controls <- startGame canvas "nyaa!" audioContext audioBuffer
            controls.start
            Ref.write controls.kill killRef
          Nothing ->
            pure unit
    gameEnd = do
      v <- Ref.read killRef
      v
  customComponent name {} gameStart gameEnd \_ ->
    [ ionContent (oneOf [ I.Fullscren !:= true ])
        [ D.canvas (oneOf [ klass_ "absolute w-full h-full", id_ (name <> "-canvas") ])
            [
            ]
        , D.div (oneOf [ klass_ "absolute w-full h-full grid grid-cols-3 grid-rows-3" ])
            [ upperLeftBackButton
            , D.span (oneOf [ id_ "score", klass_ "text-white col-start-3 justify-self-end m-4 text-2xl font-mono" ])
                [ text_ "0000000"
                ]
            , D.span (oneOf [ id_ "judgment", klass_ "text-white row-start-2 col-start-2 justify-self-center self-center text-2xl" ])
                [ text_ "..."
                ]
            ]
        ]
    ]
