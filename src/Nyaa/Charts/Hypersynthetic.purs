module Nyaa.Charts.Hypersynthetic where

import Prelude

import Data.Array as Array
import Nyaa.Charts.NoteInfo (NoteInfo, cFour, cOne, cThree, cTwo)

tresilloMeasureLength :: Number
tresilloMeasureLength = 60.0 / 152.0 * 4.0 * 7.0 / 8.0

tresilloToTime :: Number -> Number -> Number
tresilloToTime measureCount beatCount = 
  let
    measureCount' = max (measureCount - 1.0) 0.0
    beatCount' = max (beatCount - 1.0) 0.0
  in
    tresilloMeasureLength * measureCount' + tresilloLength * beatCount'

tresilloLength :: Number
tresilloLength = (60.0 / 152.0 * 4.0 * 7.0 / 8.0) / 7.0
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
  [ { timing: tresilloToTime 10.0 2.0, column: cFour }
  , { timing: tresilloToTime 10.0 3.5, column: cFour }
  , { timing: tresilloToTime 10.0 5.0, column: cThree }
  , { timing: tresilloToTime 10.0 6.5, column: cThree }
  , { timing: tresilloToTime 11.0 0.0, column: cOne }
  , { timing: tresilloToTime 11.0 2.5, column: cOne }
  , { timing: tresilloToTime 11.0 4.0, column: cTwo }
  , { timing: tresilloToTime 11.0 5.5, column: cTwo }
  , { timing: tresilloToTime 11.0 6.5, column: cThree }
  , { timing: tresilloToTime 12.0 0.0, column: cFour }
  , { timing: tresilloToTime 12.0 2.5, column: cOne }
  , { timing: tresilloToTime 12.0 3.0, column: cOne }
  , { timing: tresilloToTime 12.0 3.5, column: cOne }
  , { timing: tresilloToTime 12.0 5.5, column: cTwo }
  , { timing: tresilloToTime 12.0 7.0, column: cFour }
  , { timing: tresilloToTime 13.0 1.5, column: cOne }
  , { timing: tresilloToTime 13.0 3.0, column: cThree }
  , { timing: tresilloToTime 13.0 4.5, column: cThree }
  , { timing: tresilloToTime 13.0 6.0, column: cFour }
  , { timing: tresilloToTime 13.0 7.5, column: cThree }
  , { timing: tresilloToTime 14.0 1.5, column: cTwo }
  , { timing: tresilloToTime 14.0 3.0, column: cOne }
  , { timing: tresilloToTime 14.0 5.0, column: cFour }
  , { timing: tresilloToTime 14.0 5.5, column: cFour }
  , { timing: tresilloToTime 14.0 6.0, column: cFour }
  , { timing: tresilloToTime 14.0 7.5, column: cThree }
  , { timing: tresilloToTime 15.0 2.0, column: cOne }
  , { timing: tresilloToTime 15.0 3.5, column: cFour }
  , { timing: tresilloToTime 15.0 5.0, column: cTwo }
  , { timing: tresilloToTime 15.0 6.5, column: cThree }
  , { timing: tresilloToTime 16.0 1.0, column: cFour }
  , { timing: tresilloToTime 16.0 2.5, column: cFour }
  , { timing: tresilloToTime 16.0 3.5, column: cThree }
  , { timing: tresilloToTime 16.0 5.0, column: cTwo }
  , { timing: tresilloToTime 16.0 7.0, column: cOne }
  , { timing: tresilloToTime 16.0 7.5, column: cOne }
  , { timing: tresilloToTime 17.0 1.0, column: cOne }
  , { timing: tresilloToTime 17.0 2.5, column: cTwo }
  , { timing: tresilloToTime 17.0 4.0, column: cTwo }
  , { timing: tresilloToTime 17.0 5.5, column: cThree }
  , { timing: tresilloToTime 17.0 7.0, column: cThree }
  , { timing: tresilloToTime 18.0 1.5, column: cFour }
  , { timing: tresilloToTime 18.0 3.0, column: cFour }
  , { timing: tresilloToTime 18.0 4.5, column: cOne }
  , { timing: tresilloToTime 18.0 5.5, column: cOne }
  , { timing: tresilloToTime 18.0 7.0, column: cThree }
  , { timing: tresilloToTime 19.0 1.0, column: cFour }
  , { timing: tresilloToTime 19.0 1.5, column: cFour }
  , { timing: tresilloToTime 19.0 2.0, column: cFour }
  , { timing: tresilloToTime 19.0 3.0, column: cOne }
  , { timing: tresilloToTime 19.0 6.0, column: cOne }
  , { timing: tresilloToTime 20.0 2.0, column: cOne }
  , { timing: tresilloToTime 20.0 4.0, column: cOne }
  , { timing: tresilloToTime 20.0 7.0, column: cOne }
  , { timing: tresilloToTime 21.0 2.0, column: cTwo }
  , { timing: tresilloToTime 21.0 3.0, column: cTwo }
  , { timing: tresilloToTime 21.0 3.0, column: cThree }
  , { timing: tresilloToTime 21.0 4.0, column: cThree }
  , { timing: tresilloToTime 21.0 5.0, column: cFour }
  , { timing: tresilloToTime 22.0 1.0, column: cFour }
  , { timing: tresilloToTime 22.0 4.0, column: cFour }
  , { timing: tresilloToTime 22.0 6.0, column: cFour }
  , { timing: tresilloToTime 23.0 2.0, column: cFour }
  , { timing: tresilloToTime 23.0 4.0, column: cThree }
  , { timing: tresilloToTime 23.0 5.0, column: cThree }
  , { timing: tresilloToTime 23.0 5.0, column: cTwo }
  , { timing: tresilloToTime 23.0 6.0, column: cTwo }
  , { timing: tresilloToTime 23.0 7.0, column: cOne }
  , { timing: tresilloToTime 24.0 3.0, column: cOne }
  , { timing: tresilloToTime 24.0 6.0, column: cOne }
  , { timing: tresilloToTime 25.0 1.0, column: cOne }
  , { timing: tresilloToTime 25.0 4.0, column: cOne }
  , { timing: tresilloToTime 25.0 7.0, column: cFour }
  , { timing: tresilloToTime 26.0 2.0, column: cFour }
  , { timing: tresilloToTime 26.0 5.0, column: cFour }
  , { timing: tresilloToTime 27.0 1.0, column: cThree }
  , { timing: tresilloToTime 27.0 2.0, column: cTwo }
  , { timing: tresilloToTime 27.0 3.0, column: cOne }
  , { timing: tresilloToTime 27.0 6.0, column: cOne }
  , { timing: tresilloToTime 27.0 7.0, column: cTwo }
  , { timing: tresilloToTime 28.0 1.0, column: cThree }
  , { timing: tresilloToTime 28.0 2.0, column: cFour }
  , { timing: tresilloToTime 28.0 3.0, column: cFour }
  , { timing: tresilloToTime 28.0 4.0, column: cOne }
  , { timing: tresilloToTime 28.0 6.0, column: cOne }
  , { timing: tresilloToTime 29.0 1.0, column: cOne }
  , { timing: tresilloToTime 29.0 3.0, column: cOne }
  , { timing: tresilloToTime 29.0 5.0, column: cOne }
  , { timing: tresilloToTime 29.0 7.0, column: cOne }
  , { timing: tresilloToTime 30.0 2.0, column: cOne }
  , { timing: tresilloToTime 30.0 4.0, column: cOne }
  , { timing: tresilloToTime 30.0 6.0, column: cTwo }
  , { timing: tresilloToTime 31.0 1.0, column: cTwo }
  , { timing: tresilloToTime 31.0 3.0, column: cTwo }
  , { timing: tresilloToTime 31.0 5.0, column: cTwo }
  , { timing: tresilloToTime 31.0 7.0, column: cTwo }
  , { timing: tresilloToTime 32.0 2.0, column: cTwo }
  , { timing: tresilloToTime 32.0 4.0, column: cTwo }
  , { timing: tresilloToTime 32.0 6.0, column: cTwo }
  , { timing: tresilloToTime 33.0 1.0, column: cThree }
  , { timing: tresilloToTime 33.0 3.0, column: cThree }
  , { timing: tresilloToTime 33.0 5.0, column: cThree }
  , { timing: tresilloToTime 33.0 7.0, column: cThree }
  , { timing: tresilloToTime 34.0 2.0, column: cThree }
  , { timing: tresilloToTime 34.0 4.0, column: cThree }
  , { timing: tresilloToTime 34.0 6.0, column: cThree }
  , { timing: tresilloToTime 35.0 1.0, column: cThree }
  , { timing: tresilloToTime 35.0 3.0, column: cFour }
  , { timing: tresilloToTime 35.0 4.0, column: cFour }
  , { timing: tresilloToTime 35.0 5.0, column: cTwo }
  , { timing: tresilloToTime 35.0 6.0, column: cTwo }
  , { timing: tresilloToTime 35.0 7.0, column: cThree }
  , { timing: tresilloToTime 36.0 1.0, column: cThree }
  , { timing: tresilloToTime 36.0 2.0, column: cOne }
  , { timing: tresilloToTime 36.0 3.0, column: cOne }
  , { timing: tresilloToTime 36.0 4.0, column: cTwo }
  , { timing: tresilloToTime 36.0 4.0, column: cThree }
  ]

coreMeasureLength :: Number
coreMeasureLength  = 60.0 / 152.0 * 4.0

coreLength :: Number
coreLength = 60.0 / 152.0

coreToTime :: Number -> Number -> Number
coreToTime measureCount beatCount = 
  let
    measureCount' = max (measureCount - 1.0) 0.0
    beatCount' = max (beatCount - 1.0) 0.0
  in
    coreMeasureLength * measureCount' + coreLength * beatCount'

coreNotes :: Array NoteInfo
coreNotes =
  [ { timing: coreToTime 33.0 1.0, column: cOne }
  , { timing: coreToTime 33.0 1.0, column: cFour }
  , { timing: coreToTime 33.0 3.0, column: cTwo }
  , { timing: coreToTime 33.0 4.0, column: cThree }
  , { timing: coreToTime 34.0 2.0, column: cThree }
  , { timing: coreToTime 34.0 3.0, column: cTwo }
  , { timing: coreToTime 34.0 4.0, column: cThree }
  , { timing: coreToTime 35.0 1.0, column: cOne }
  , { timing: coreToTime 35.0 1.0, column: cFour }
  , { timing: coreToTime 35.0 2.0, column: cThree }
  , { timing: coreToTime 35.0 3.0, column: cThree }
  , { timing: coreToTime 35.0 4.0, column: cOne }
  , { timing: coreToTime 35.0 4.0, column: cFour }
  , { timing: coreToTime 36.0 1.0, column: cTwo }
  , { timing: coreToTime 36.0 2.0, column: cTwo }
  , { timing: coreToTime 36.0 3.0, column: cThree }
  , { timing: coreToTime 36.0 4.0, column: cThree }
  , { timing: coreToTime 37.0 1.0, column: cOne }
  , { timing: coreToTime 37.0 1.0, column: cFour }
  , { timing: coreToTime 37.0 3.0, column: cOne }
  , { timing: coreToTime 37.0 3.0, column: cTwo }
  , { timing: coreToTime 37.0 4.0, column: cOne }
  , { timing: coreToTime 37.0 4.0, column: cThree }
  , { timing: coreToTime 38.0 2.0, column: cThree }
  , { timing: coreToTime 38.0 2.0, column: cFour }
  , { timing: coreToTime 38.0 3.0, column: cTwo }
  , { timing: coreToTime 38.0 3.0, column: cFour }
  , { timing: coreToTime 38.0 4.0, column: cOne }
  , { timing: coreToTime 39.0 1.0, column: cOne }
  , { timing: coreToTime 39.0 1.0, column: cThree }
  , { timing: coreToTime 39.0 3.0, column: cFour }
  , { timing: coreToTime 39.0 4.0, column: cTwo }
  , { timing: coreToTime 39.0 4.0, column: cFour }
  , { timing: coreToTime 40.0 2.75, column: cOne }
  , { timing: coreToTime 40.0 3.00, column: cOne }
  , { timing: coreToTime 41.0 1.0, column: cTwo }
  , { timing: coreToTime 41.0 1.0, column: cFour }
  , { timing: coreToTime 41.0 3.0, column: cTwo }
  , { timing: coreToTime 41.0 3.0, column: cFour }
  , { timing: coreToTime 41.0 4.0, column: cTwo }
  , { timing: coreToTime 41.0 4.0, column: cFour }
  , { timing: coreToTime 42.0 1.5, column: cThree }
  , { timing: coreToTime 42.0 2.0, column: cTwo }
  , { timing: coreToTime 42.0 2.5, column: cThree }
  , { timing: coreToTime 42.0 3.0, column: cOne }
  , { timing: coreToTime 42.0 3.0, column: cTwo }
  , { timing: coreToTime 42.0 4.0, column: cOne }
  , { timing: coreToTime 42.0 4.0, column: cThree }
  , { timing: coreToTime 43.0 1.0, column: cOne }
  , { timing: coreToTime 43.0 1.0, column: cTwo }
  , { timing: coreToTime 43.0 3.0, column: cThree }
  , { timing: coreToTime 43.0 4.0, column: cThree }
  , { timing: coreToTime 44.0 1.0, column: cFour }
  , { timing: coreToTime 44.0 2.0, column: cTwo }
  , { timing: coreToTime 44.0 3.0, column: cTwo }
  , { timing: coreToTime 44.0 4.0, column: cOne }
  , { timing: coreToTime 45.0 1.0, column: cOne }
  , { timing: coreToTime 45.0 1.0, column: cFour }
  , { timing: coreToTime 45.0 3.0, column: cOne }
  , { timing: coreToTime 45.0 3.0, column: cFour }
  , { timing: coreToTime 45.0 4.0, column: cOne }
  , { timing: coreToTime 45.0 4.0, column: cFour }
  , { timing: coreToTime 46.0 1.0, column: cTwo }
  , { timing: coreToTime 46.0 1.5, column: cTwo }
  , { timing: coreToTime 46.0 2.0, column: cThree }
  , { timing: coreToTime 46.0 2.5, column: cThree }
  , { timing: coreToTime 46.0 3.0, column: cOne }
  , { timing: coreToTime 46.0 3.0, column: cFour }
  , { timing: coreToTime 46.0 4.0, column: cOne }
  , { timing: coreToTime 46.0 4.0, column: cFour }
  , { timing: coreToTime 46.0 4.5, column: cOne }
  , { timing: coreToTime 46.0 4.5, column: cFour }
  , { timing: coreToTime 47.0 1.0, column: cTwo }
  , { timing: coreToTime 47.0 1.0, column: cThree }
  , { timing: coreToTime 47.0 3.0, column: cTwo }
  , { timing: coreToTime 47.0 3.0, column: cThree }
  , { timing: coreToTime 47.0 4.0, column: cTwo }
  , { timing: coreToTime 47.0 4.0, column: cThree }
  , { timing: coreToTime 48.0 2.75, column: cOne }
  , { timing: coreToTime 48.0 2.75, column: cThree }
  , { timing: coreToTime 48.0 3.0, column: cOne }
  , { timing: coreToTime 48.0 3.0, column: cTwo }
  , { timing: coreToTime 49.0 1.0, column: cThree }
  , { timing: coreToTime 49.0 1.0, column: cFour }
  , { timing: coreToTime 49.0 3.0, column: cTwo }
  , { timing: coreToTime 49.0 3.0, column: cFour }
  , { timing: coreToTime 49.0 4.0, column: cTwo }
  , { timing: coreToTime 49.0 4.0, column: cFour }
  , { timing: coreToTime 50.0 2.0, column: cOne }
  , { timing: coreToTime 50.0 3.0, column: cOne }
  , { timing: coreToTime 50.0 4.0, column: cOne }
  , { timing: coreToTime 51.0 1.0, column: cTwo }
  , { timing: coreToTime 51.0 1.0, column: cThree }
  , { timing: coreToTime 51.0 3.0, column: cTwo }
  , { timing: coreToTime 51.0 2.0, column: cFour }
  , { timing: coreToTime 51.0 2.0, column: cTwo }
  , { timing: coreToTime 51.0 3.0, column: cThree }
  , { timing: coreToTime 51.0 4.0, column: cTwo }
  , { timing: coreToTime 51.0 4.0, column: cFour }
  , { timing: coreToTime 52.0 2.0, column: cOne }
  , { timing: coreToTime 52.0 2.0, column: cThree }
  , { timing: coreToTime 52.0 3.0, column: cOne }
  , { timing: coreToTime 52.0 3.0, column: cTwo }
  , { timing: coreToTime 52.0 4.0, column: cOne }
  , { timing: coreToTime 52.0 4.0, column: cThree }
  , { timing: coreToTime 53.0 1.0, column: cOne }
  , { timing: coreToTime 53.0 1.0, column: cFour }
  , { timing: coreToTime 53.0 3.0, column: cTwo }
  , { timing: coreToTime 53.0 3.0, column: cThree }
  , { timing: coreToTime 53.0 4.0, column: cThree }
  , { timing: coreToTime 54.0 2.0, column: cTwo }
  , { timing: coreToTime 54.0 3.0, column: cTwo }
  , { timing: coreToTime 54.0 3.0, column: cThree }
  , { timing: coreToTime 55.0 1.0, column: cOne }
  , { timing: coreToTime 55.0 1.0, column: cFour }
  , { timing: coreToTime 55.0 3.0, column: cOne }
  , { timing: coreToTime 55.0 3.5, column: cTwo }
  , { timing: coreToTime 55.0 4.0, column: cThree }
  , { timing: coreToTime 56.0 2.75, column: cFour }
  , { timing: coreToTime 56.0 3.0, column: cFour }
  , { timing: coreToTime 57.0 1.0, column: cOne }
  , { timing: coreToTime 57.0 1.0, column: cTwo }
  , { timing: coreToTime 57.0 3.0, column: cThree }
  , { timing: coreToTime 57.0 4.0, column: cFour }
  , { timing: coreToTime 58.0 1.0, column: cTwo }
  , { timing: coreToTime 58.0 1.5, column: cOne }
  , { timing: coreToTime 58.0 2.0, column: cTwo }
  , { timing: coreToTime 58.0 2.5, column: cOne }
  , { timing: coreToTime 58.0 3.0, column: cThree }
  , { timing: coreToTime 58.0 3.5, column: cTwo }
  , { timing: coreToTime 58.0 4.0, column: cOne }
  , { timing: coreToTime 59.0 1.0, column: cOne }
  , { timing: coreToTime 59.0 1.0, column: cFour }
  , { timing: coreToTime 59.0 3.0, column: cOne }
  , { timing: coreToTime 59.0 3.0, column: cThree }
  , { timing: coreToTime 59.0 4.0, column: cOne }
  , { timing: coreToTime 59.0 4.0, column: cTwo }
  , { timing: coreToTime 60.0 2.0, column: cThree }
  , { timing: coreToTime 60.0 2.0, column: cFour }
  , { timing: coreToTime 60.0 3.0, column: cTwo }
  , { timing: coreToTime 60.0 3.0, column: cFour }
  , { timing: coreToTime 61.0 1.0, column: cOne }
  , { timing: coreToTime 61.0 1.0, column: cFour }
  , { timing: coreToTime 61.0 3.0, column: cTwo }
  , { timing: coreToTime 61.0 3.0, column: cThree }
  , { timing: coreToTime 61.0 4.0, column: cThree }
  , { timing: coreToTime 62.0 2.0, column: cTwo }
  , { timing: coreToTime 62.0 3.0, column: cTwo }
  , { timing: coreToTime 62.0 3.0, column: cThree }
  , { timing: coreToTime 63.0 1.0, column: cOne }
  , { timing: coreToTime 63.0 1.0, column: cFour }
  , { timing: coreToTime 63.0 3.0, column: cOne }
  , { timing: coreToTime 63.0 3.5, column: cTwo }
  , { timing: coreToTime 63.0 4.0, column: cThree }
  , { timing: coreToTime 64.0 2.75, column: cFour }
  , { timing: coreToTime 64.0 3.0, column: cFour }
  , { timing: coreToTime 65.0 1.0, column: cOne }
  ]

outroNotes :: Array NoteInfo
outroNotes =
  [ { timing: coreToTime 65.0 2.5, column: cOne }
  , { timing: coreToTime 65.0 4.0, column: cOne }
  , { timing: coreToTime 66.0 1.0, column: cTwo }
  , { timing: coreToTime 66.0 2.5, column: cTwo }
  , { timing: coreToTime 66.0 4.0, column: cTwo }
  , { timing: coreToTime 67.0 1.0, column: cThree }
  , { timing: coreToTime 67.0 2.5, column: cThree }
  , { timing: coreToTime 67.0 4.0, column: cThree }
  , { timing: coreToTime 68.0 1.0, column: cFour }
  , { timing: coreToTime 68.0 2.5, column: cFour }
  , { timing: coreToTime 68.0 4.0, column: cFour }
  , { timing: coreToTime 69.0 1.0, column: cOne }
  , { timing: coreToTime 69.0 2.5, column: cOne }
  , { timing: coreToTime 69.0 4.0, column: cOne }
  , { timing: coreToTime 70.0 1.0, column: cTwo }
  , { timing: coreToTime 70.0 2.5, column: cTwo }
  , { timing: coreToTime 70.0 4.0, column: cTwo }
  , { timing: coreToTime 71.0 1.0, column: cThree }
  , { timing: coreToTime 71.0 2.5, column: cThree }
  , { timing: coreToTime 71.0 4.0, column: cThree }
  , { timing: coreToTime 72.0 1.0, column: cFour }
  , { timing: coreToTime 72.0 2.5, column: cFour }
  , { timing: coreToTime 72.0 4.0, column: cFour }
  ]

hypersynthetic :: Array NoteInfo
hypersynthetic = introNotes <> melodyNotes <> coreNotes <> outroNotes