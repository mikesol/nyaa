module Nyaa.Custom.Pages.TutorialPage where

import Prelude

import Data.Foldable (oneOf)
import Data.Maybe (Maybe(..))
import Deku.Attribute ((!:=))
import Deku.Attributes (id_, klass_)
import Deku.Control (text_)
import Deku.Core (Nut)
import Deku.DOM as D
import Deku.Listeners (click_)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Nyaa.Assets (logoURL, tutorial0URL, tutorial1URL, tutorial2URL)
import Nyaa.Custom.Pages.DevAdmin (doScorelessAchievement, track1Achievement)
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
slideOneText = "Welcome to Nyaa's tutorial! Swipe left to continue!"

slideTwoText :: String
slideTwoText =
  """
Nya is a vertical scrolling rhythm game with a twist!
The arena is divided between you and your opponent,
and notes come from the middle of the arena. You must hit notes as they
approach your judgment guides!
"""

slideThreeText :: String
slideThreeText =
  """
In the upper right, you can see your score in blue and your opponent's in green.
"Judgment" text
may appear in the middle of the screen showing how well you hit a specific note!
"""

slideFourText :: String
slideFourText =
  """
During gameplay, you will earn abilities that you can use to
throw your opponent off guard. These abilities can be activated through the buttons in the upper left.
"""

slideFiveText :: String
slideFiveText =
  """
Go forth and appease the cat overlord!
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

    tutorialSlide :: String -> String -> Nut
    tutorialSlide imageURL textContent =
      D.div (oneOf [ klass_ "swiper-slide p-4 grid grid-rows-3 grid-cols-3" ])
        [ D.div (oneOf [ klass_ "px-12 col-span-3 row-span-2 flex justify-center" ])
            [ D.img (oneOf [ D.Src !:= imageURL, klass_ "max-h-full bg-stone-800 p-4" ])
                [
                ]
            ]
        , D.article
            ( oneOf
                [ klass_
                    "px-12 col-start-1 row-start-3 col-span-3 place-self-center"
                ]
            )
            [ text_ textContent
            ]
        ]

    finalSlide :: Nut
    finalSlide =
      D.div (oneOf [ klass_ "swiper-slide p-4 grid grid-rows-2 grid-cols-5" ])
        [ D.article
            ( oneOf
                [ klass_
                    "text-2xl col-start-1 col-span-5 px-12 place-self-center"
                ]
            )
            [ text_ slideFiveText
            ]
        , ionButton
            ( oneOf
                [ klass_ "col-start-2 col-span-3"
                , D.Href !:= "/intro-screen"
                , click_ $ launchAff_ do
                    doScorelessAchievement track1Achievement
                ]
            )
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
                  [ tutorialSlide logoURL slideOneText
                  , tutorialSlide tutorial0URL slideTwoText
                  , tutorialSlide tutorial1URL slideThreeText
                  , tutorialSlide tutorial2URL slideFourText
                  , finalSlide
                  ]
              , D.div (oneOf [ klass_ "swiper-button-prev" ]) []
              , D.div (oneOf [ klass_ "swiper-button-next" ]) []
              ]
          ]
      ]