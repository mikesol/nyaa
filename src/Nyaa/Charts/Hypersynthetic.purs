module Nyaa.Charts.Hypersynthetic where

import Prelude

import Data.Array as Array
import Nyaa.Charts.NoteInfo (NoteInfo, cFour, cOne, cThree, cTwo)

measureLength :: Number
measureLength = 60.0 / 152.0 * 4.0 * 7.0 / 8.0

toTime :: Number -> Number -> Number
toTime measureCount beatCount = 
  let
    measureCount' = max (measureCount - 1.0) 0.0
    beatCount' = max (beatCount - 1.0) 0.0
  in
    measureLength * measureCount' + tresilloLength * beatCount'

tresilloLength :: Number
tresilloLength = (60.0 / 152.0 * 4.0 * 7.0 / 8.0) / 7.0

melodyStart :: Number
melodyStart = (tresilloLength * 7.0) * 9.0 + tresilloLength

introNotes :: Array NoteInfo
introNotes =
  [ { timing: tresilloLength * 32.0, column: cFour }
  , { timing: tresilloLength * 35.0, column: cFour }
  , { timing: tresilloLength * 38.0, column: cFour }
  , { timing: tresilloLength * 40.0, column: cThree }
  , { timing: tresilloLength * 43.0, column: cThree }
  , { timing: tresilloLength * 46.0, column: cThree }
  , { timing: tresilloLength * 48.0, column: cTwo }
  , { timing: tresilloLength * 51.0, column: cTwo }
  , { timing: tresilloLength * 54.0, column: cTwo }
  , { timing: tresilloLength * 56.0, column: cOne }
  , { timing: tresilloLength * 59.0, column: cOne }
  , { timing: tresilloLength * 62.0, column: cOne }
  ]

melodyNotes :: Array NoteInfo
melodyNotes = Array.sort
  [ { timing: toTime 10.0 2.0, column: cFour }
  , { timing: toTime 10.0 3.5, column: cFour }
  , { timing: toTime 10.0 5.0, column: cThree }
  , { timing: toTime 10.0 6.5, column: cThree }
  , { timing: toTime 11.0 0.0, column: cOne }
  , { timing: toTime 11.0 2.5, column: cOne }
  , { timing: toTime 11.0 4.0, column: cTwo }
  , { timing: toTime 11.0 5.5, column: cTwo }
  , { timing: toTime 11.0 6.5, column: cThree }
  , { timing: toTime 12.0 0.0, column: cFour }
  , { timing: toTime 12.0 2.5, column: cOne }
  , { timing: toTime 12.0 3.0, column: cOne }
  , { timing: toTime 12.0 3.5, column: cOne }
  , { timing: toTime 12.0 5.5, column: cTwo }
  , { timing: toTime 12.0 7.0, column: cFour }
  , { timing: toTime 13.0 1.5, column: cOne }
  , { timing: toTime 13.0 3.0, column: cThree }
  , { timing: toTime 13.0 4.5, column: cThree }
  , { timing: toTime 13.0 6.0, column: cFour }
  , { timing: toTime 13.0 7.5, column: cThree }
  , { timing: toTime 14.0 1.5, column: cTwo }
  , { timing: toTime 14.0 3.0, column: cOne }
  , { timing: toTime 14.0 5.0, column: cFour }
  , { timing: toTime 14.0 5.5, column: cFour }
  , { timing: toTime 14.0 6.0, column: cFour }
  , { timing: toTime 14.0 7.5, column: cThree }
  , { timing: toTime 15.0 2.0, column: cOne }
  , { timing: toTime 15.0 3.5, column: cFour }
  , { timing: toTime 15.0 5.0, column: cTwo }
  , { timing: toTime 15.0 6.5, column: cThree }
  , { timing: toTime 16.0 1.0, column: cFour }
  , { timing: toTime 16.0 2.5, column: cFour }
  , { timing: toTime 16.0 3.5, column: cThree }
  , { timing: toTime 16.0 5.0, column: cTwo }
  , { timing: toTime 16.0 7.0, column: cOne }
  , { timing: toTime 16.0 7.5, column: cOne }
  , { timing: toTime 17.0 1.0, column: cOne }
  , { timing: toTime 17.0 2.5, column: cTwo }
  , { timing: toTime 17.0 4.0, column: cTwo }
  , { timing: toTime 17.0 5.5, column: cThree }
  , { timing: toTime 17.0 7.0, column: cThree }
  , { timing: toTime 18.0 1.5, column: cFour }
  , { timing: toTime 18.0 3.0, column: cFour }
  , { timing: toTime 18.0 4.5, column: cOne }
  , { timing: toTime 18.0 5.5, column: cOne }
  , { timing: toTime 18.0 7.0, column: cThree }
  , { timing: toTime 19.0 1.0, column: cFour }
  , { timing: toTime 19.0 1.5, column: cFour }
  , { timing: toTime 19.0 2.0, column: cFour }
  , { timing: toTime 19.0 3.0, column: cOne }
  , { timing: toTime 19.0 6.0, column: cOne }
  , { timing: toTime 20.0 2.0, column: cOne }
  , { timing: toTime 20.0 4.0, column: cOne }
  , { timing: toTime 20.0 7.0, column: cOne }
  , { timing: toTime 21.0 2.0, column: cTwo }
  , { timing: toTime 21.0 3.0, column: cTwo }
  , { timing: toTime 21.0 3.0, column: cThree }
  , { timing: toTime 21.0 4.0, column: cThree }
  , { timing: toTime 21.0 5.0, column: cFour }
  , { timing: toTime 22.0 1.0, column: cFour }
  , { timing: toTime 22.0 4.0, column: cFour }
  , { timing: toTime 22.0 6.0, column: cFour }
  , { timing: toTime 23.0 2.0, column: cFour }
  , { timing: toTime 23.0 4.0, column: cThree }
  , { timing: toTime 23.0 5.0, column: cThree }
  , { timing: toTime 23.0 5.0, column: cTwo }
  , { timing: toTime 23.0 6.0, column: cTwo }
  , { timing: toTime 23.0 7.0, column: cOne }
  , { timing: toTime 24.0 3.0, column: cOne }
  , { timing: toTime 24.0 6.0, column: cOne }
  , { timing: toTime 25.0 1.0, column: cOne }
  , { timing: toTime 25.0 4.0, column: cOne }
  , { timing: toTime 25.0 7.0, column: cFour }
  , { timing: toTime 26.0 2.0, column: cFour }
  , { timing: toTime 26.0 5.0, column: cFour }
  , { timing: toTime 27.0 1.0, column: cThree }
  , { timing: toTime 27.0 2.0, column: cTwo }
  , { timing: toTime 27.0 3.0, column: cOne }
  , { timing: toTime 27.0 6.0, column: cOne }
  , { timing: toTime 27.0 7.0, column: cTwo }
  , { timing: toTime 28.0 1.0, column: cThree }
  , { timing: toTime 28.0 2.0, column: cFour }
  , { timing: toTime 28.0 3.0, column: cFour }
  , { timing: toTime 28.0 4.0, column: cOne }
  , { timing: toTime 28.0 6.0, column: cOne }
  , { timing: toTime 29.0 1.0, column: cOne }
  , { timing: toTime 29.0 3.0, column: cOne }
  , { timing: toTime 29.0 5.0, column: cOne }
  , { timing: toTime 29.0 7.0, column: cOne }
  , { timing: toTime 30.0 2.0, column: cOne }
  , { timing: toTime 30.0 4.0, column: cOne }
  , { timing: toTime 30.0 6.0, column: cTwo }
  , { timing: toTime 31.0 1.0, column: cTwo }
  , { timing: toTime 31.0 3.0, column: cTwo }
  , { timing: toTime 31.0 5.0, column: cTwo }
  , { timing: toTime 31.0 7.0, column: cTwo }
  , { timing: toTime 32.0 2.0, column: cTwo }
  , { timing: toTime 32.0 4.0, column: cTwo }
  , { timing: toTime 32.0 6.0, column: cTwo }
  , { timing: toTime 33.0 1.0, column: cThree }
  , { timing: toTime 33.0 3.0, column: cThree }
  , { timing: toTime 33.0 5.0, column: cThree }
  , { timing: toTime 33.0 7.0, column: cThree }
  , { timing: toTime 34.0 2.0, column: cThree }
  , { timing: toTime 34.0 4.0, column: cThree }
  , { timing: toTime 34.0 6.0, column: cThree }
  , { timing: toTime 35.0 1.0, column: cThree }
  , { timing: toTime 35.0 3.0, column: cFour }
  , { timing: toTime 35.0 4.0, column: cFour }
  , { timing: toTime 35.0 5.0, column: cTwo }
  , { timing: toTime 35.0 6.0, column: cTwo }
  , { timing: toTime 35.0 7.0, column: cThree }
  , { timing: toTime 36.0 1.0, column: cThree }
  , { timing: toTime 36.0 2.0, column: cOne }
  , { timing: toTime 36.0 3.0, column: cOne }
  , { timing: toTime 36.0 4.0, column: cTwo }
  , { timing: toTime 36.0 4.0, column: cThree }
  ]

hypersynthetic :: Array NoteInfo
hypersynthetic = introNotes <> melodyNotes