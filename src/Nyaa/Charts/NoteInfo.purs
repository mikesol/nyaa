module Nyaa.Charts.NoteInfo (NoteInfo, Column, cOne, cTwo, cThree, cFour) where

import Data.Eq (class Eq)
import Data.Ord (class Ord)

newtype Column = Column Int

derive newtype instance Eq Column
derive newtype instance Ord Column

cOne :: Column
cOne = Column 0

cTwo :: Column
cTwo = Column 1

cThree :: Column
cThree = Column 2

cFour :: Column
cFour = Column 3

type NoteInfo = { timing :: Number, column :: Column }