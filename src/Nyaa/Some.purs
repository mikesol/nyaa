module Nyaa.Some where


import Prelude

import Data.Maybe (Maybe(..))
import Data.Symbol (class IsSymbol, reflectSymbol)
import Prim.Row (class Cons, class Union)
import Type.Proxy (Proxy)
import Unsafe.Coerce (unsafeCoerce)

data Some :: Row Type -> Type
data Some r

derive instance Eq (Some r)

foreign import getImpl :: forall r a. (a -> Maybe a) -> Maybe a -> String -> Some r -> Maybe a

get :: forall r r' l a. IsSymbol l => Cons l a r' r => Proxy l -> Some r -> Maybe a
get p = getImpl Just Nothing (reflectSymbol p)

foreign import setImpl :: forall r a. String -> a -> Some r -> Some r

set :: forall r r' l a. IsSymbol l => Cons l a r' r => Proxy l -> a -> Some r -> Some r
set p = setImpl (reflectSymbol p)

some :: forall x y z. Union x y z => { | x } -> Some z
some = unsafeCoerce