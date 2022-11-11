module Nyaa.Custom.Builders.Game where

import Prelude

import Data.Foldable (oneOf)
import Data.Tuple.Nested ((/\))
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Core (envy)
import Deku.DOM as D
import Deku.Do (useState)
import Deku.Do as Deku
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Ref as Ref
import FRP.Event (makeEvent, subscribe)
import Nyaa.Components.UpperLeftBackButton (upperLeftBackButton)
import Nyaa.FRP.Rider (rider, toRide)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Content (ionContent)
import Nyaa.Ionic.Custom (customComponent)
import Ocarina.Interpret (decodeAudioDataFromUri)
import Ocarina.WebAPI (AudioContext, BrowserAudioBuffer)
import Web.HTML (HTMLCanvasElement)

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
game i = customComponent i.name {} \_ ->
  [ Deku.do
      setKill /\ kill <- useState (pure unit)
      envy
        -- a bit kludgy... but it works!
        $ rider
            ( toRide
                { event: makeEvent \_ -> do
                    r <- Ref.new (pure unit)
                    u <- subscribe kill \x -> Ref.write x r
                    pure do
                      u
                      v <- Ref.read r
                      v
                , push: const $ pure unit
                }
            )
        $ pure
            ( ionContent (oneOf [ I.Fullscren !:= true ])
                [ D.canvas
                    ( oneOf
                        [ klass_ "absolute w-full h-full"
                        , D.SelfT !:= \c -> launchAff_ do
                            audioBuffer <- decodeAudioDataFromUri i.audioContext i.audioUri
                            liftEffect do
                              controls <- startGame c "nyaa!" i.audioContext audioBuffer
                              setKill controls.kill
                              controls.start
                              pure unit
                        ]
                    )
                    []
                , D.div
                    ( oneOf
                        [ klass_
                            "absolute w-full h-full grid grid-cols-3 grid-rows-3"
                        ]
                    )
                    [ upperLeftBackButton
                    ]
                ]
            )
  ]