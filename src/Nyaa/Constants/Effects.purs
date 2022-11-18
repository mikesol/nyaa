module Nyaa.Constants.Effects where

import Data.Newtype (class Newtype)

newtype EffectTiming = EffectTiming { duration :: Number }

derive instance Newtype EffectTiming _

type EffectHolder v =
  { flat :: v
  , buzz :: v
  , glide :: v
  , back :: v
  , rotate :: v
  , hide :: v
  , dazzle :: v
  , crush :: v
  , amplify :: v
  }

type EffectTimings = EffectHolder EffectTiming

effectTimings :: EffectTimings
effectTimings =
  { flat: EffectTiming { duration: 4.0 }
  , buzz: EffectTiming { duration: 4.0 }
  , glide: EffectTiming { duration: 4.0 }
  , back: EffectTiming { duration: 4.0 }
  , rotate: EffectTiming { duration: 4.0 }
  , hide: EffectTiming { duration: 4.0 }
  , dazzle: EffectTiming { duration: 4.0 }
  , crush: EffectTiming { duration: 4.0 }
  , amplify: EffectTiming { duration: 4.0 }
  }