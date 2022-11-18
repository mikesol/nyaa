module Nyaa.Charts.Hypersynthetic where

import Prelude

import Data.Array ((..))
import Data.Int (toNumber)
import Nyaa.Charts.NoteInfo (NoteInfo, cFour, cOne, cThree, cTwo)

hypersynthetic :: Array NoteInfo
hypersynthetic = map
  ( \x ->
      { timing: 0.4 * toNumber x
      , column: case x `mod` 4 of
          0 -> cOne
          1 -> cTwo
          2 -> cThree
          _ -> cFour
      }
  )
  (0 .. 200)