module Nyaa.Ionic.Unsafe where

-- a blob, use `unsafeCoerce` to make one
data RouterAnimation

-- ionic doesn't really document this, so we make it an opaque blob for now
-- and folks can `unsafeCoerce` something to this if they really need it
data AnimationBuilder