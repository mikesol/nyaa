module Nyaa.Charts.Tutorial where

import Prelude

import Data.Array ((..))
import Data.Int (toNumber)
import Nyaa.Charts.NoteInfo (NoteInfo, cFour, cOne, cThree, cTwo)

tutorial :: Array NoteInfo
tutorial = map
  ( \x ->
      { timing: 0.2 * toNumber x
      , column: case x `mod` 4 of
          0 -> cOne
          1 -> cTwo
          2 -> cThree
          _ -> cFour
      }
  )
  (0 .. 200)