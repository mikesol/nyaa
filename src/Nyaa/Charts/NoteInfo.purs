module Nyaa.Charts.NoteInfo (NoteInfo, Column, cOne, cTwo, cThree, cFour) where

newtype Column = Column Int

cOne :: Column
cOne = Column 0
cTwo :: Column
cTwo = Column 1
cThree :: Column
cThree = Column 2
cFour :: Column
cFour = Column 3

type NoteInfo = { timing :: Number, column :: Column }