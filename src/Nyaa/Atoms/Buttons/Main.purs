module Nyaa.Atoms.Buttons.Main where

import Prelude

import ConvertableOptions (class Defaults, defaults)
import Data.Array (intercalate)
import Data.Foldable (oneOf)
import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.Core (Domable)
import Deku.DOM as D
import Deku.Listeners (click_)
import Effect (Effect)

type Optional =
  ( textColor :: String
  , from :: String
  , via :: String
  , to :: String
  )

type All =
  ( text :: String
  , click :: Effect Unit
  | Optional
  )

defaultOptions :: { | Optional }
defaultOptions =
  { textColor: "text-gray-900"
  , from: "from-red-200"
  , via: "via-red-300"
  , to: "to-yellow-200"
  }

mainButton
  :: forall provided lock payload
   . Defaults { | Optional } { | provided } { | All }
  => { | provided }
  -> Domable lock payload
mainButton provided = D.button
  ( oneOf
      [ klass_ $ intercalate " "
          [ all.from
          , all.via
          , all.to
          , "bg-gradient-to-r hover:bg-gradient-to-bl focus:ring-4 focus:outline-none focus:ring-red-100 dark:focus:ring-red-400 font-medium rounded-lg text-lg px-5 py-2.5 text-center mr-2 mb-2"
          ]
      , click_ all.click
      ]
  )
  [ text_ all.text ]
  where
  all :: { | All }
  all = defaults defaultOptions provided