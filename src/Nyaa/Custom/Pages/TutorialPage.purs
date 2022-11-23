module Nyaa.Custom.Pages.TutorialPage where

import Prelude

import Data.Foldable (oneOf)
import Data.Maybe (Maybe(..))
import Deku.Attribute ((!:=))
import Deku.Attributes (id_, klass_)
import Deku.Control (text_)
import Deku.Core (Nut)
import Deku.DOM as D
import Effect (Effect)
import Nyaa.Ionic.Attributes as I
import Nyaa.Ionic.Button (ionButton)
import Nyaa.Ionic.Content (ionContent_)
import Nyaa.Ionic.Custom (customComponent)
import Nyaa.Ionic.Header (ionHeader)
import Nyaa.Ionic.Title (ionTitle_)
import Nyaa.Ionic.Toolbar (ionToolbar_)
import Nyaa.Swiper (createSwiper)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.Window (document)

slideOneText :: String
slideOneText = "Welcome to Nyaa's tutorial!"

slideTwoText :: String
slideTwoText = """
Nyaa is a vertical scrolling rhythm game with a twist! First and foremost,
let's talk about the UI. The arena is divided between you and your opponent,
and notes come from the middle of the track. You must hit notes as they
approach your judgment guides!
"""

slideThreeText :: String
slideThreeText = """
In the upper right, you can see you and your opponent's scores respectively.
This is an indication of how well you perform in a chart. "Judgment" text
may appear in the middle of the screen showing how well you hit a specific note!
"""

slideFourText :: String
slideFourText = """
During gameplay, you or your opponent can mess with each other through various
abilities, which can be activated through the UI in the upper right. Not all
abilities are available though, and you have to work for them in order to be
able to use them!
"""

slideFiveText :: String
slideFiveText = """
Go forth and appease the overlord!
"""

tutorialPage :: Effect Unit
tutorialPage =
  let
    startTutorial :: _ -> Effect Unit
    startTutorial _ = do
      w <- window
      d <- document w
      e <- getElementById "tutorial-content"
        (HTMLDocument.toNonElementParentNode d)
      case e of
        Just e' -> do
          _ <- createSwiper e'
          pure unit
        Nothing -> pure unit

    endTutorial :: _ -> Effect Unit
    endTutorial _ = pure unit

    tutorialSlide :: String -> Nut
    tutorialSlide textContent =
      D.div (oneOf [ klass_ "swiper-slide p-4 grid grid-rows-3 grid-cols-3" ])
        [ D.div (oneOf [ klass_ "px-12 col-span-3 row-span-2" ])
          [ D.div (oneOf [ klass_ "bg-black h-full" ]) []
          ]
        , D.article (oneOf [ klass_ "px-12 col-start-1 row-start-3 col-span-3 place-self-center" ])
          [ text_ textContent
          ]
        ]
    
    finalSlide :: Nut
    finalSlide =
      D.div (oneOf [ klass_ "swiper-slide p-4 grid grid-rows-2 grid-cols-5" ])
        [ D.article (oneOf [ klass_ "text-2xl col-start-1 col-span-5 px-12 place-self-center" ])
          [ text_ slideFiveText
          ]
        , ionButton (oneOf [ klass_ "col-start-2 col-span-3", D.Href !:= "/intro-screen" ])
          [ text_ "Finish"
          ]
        ]
  in
    customComponent "tutorial-page" {} startTutorial endTutorial \_ ->
      [ ionHeader (oneOf [ I.Translucent !:= true ])
          [ ionToolbar_
              [ ionTitle_ [ text_ "Tutorial" ]
              ]
          ]
      , ionContent_
          [ D.div (oneOf [ id_ "tutorial-content", klass_ "h-full" ])
              [ D.div (oneOf [ klass_ "swiper-wrapper" ])
                [ tutorialSlide slideOneText
                , tutorialSlide slideTwoText
                , tutorialSlide slideThreeText
                , tutorialSlide slideFourText
                , finalSlide
                ]
              , D.div (oneOf [ klass_ "swiper-button-prev" ]) []
              , D.div (oneOf [ klass_ "swiper-button-next" ]) []
              ]
          ]
      ]