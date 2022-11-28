module Nyaa.Some where

import Prelude

import Control.Monad.Except (ExceptT(..), runExceptT, withExcept)
import Data.Either (Either(..))
import Data.Function (on)
import Data.Maybe (Maybe(..))
import Data.Symbol (class IsSymbol, reflectSymbol)
import Foreign (F, Foreign, ForeignError(..), unsafeToForeign)
import Foreign.Index (readProp)
import Foreign.Object (Object)
import Prim.Row (class Cons, class Union)
import Prim.Row as Row
import Prim.RowList (class RowToList, Cons, Nil, RowList)
import Simple.JSON as JSON
import Type.Proxy (Proxy(..))
import Type.Row.Homogeneous (class Homogeneous)
import Unsafe.Coerce (unsafeCoerce)

data Some :: Row Type -> Type
data Some r

--- ughhhhh
instance JSON.WriteForeign (Some r) => Eq (Some r) where
  eq  = eq `on` JSON.writeJSON

foreign import getImpl
  :: forall r a. (a -> Maybe a) -> Maybe a -> String -> Some r -> Maybe a

get
  :: forall r r' l a
   . IsSymbol l
  => Cons l a r' r
  => Proxy l
  -> Some r
  -> Maybe a
get p = getImpl Just Nothing (reflectSymbol p)

foreign import setImpl :: forall r a. String -> a -> Some r -> Some r

set
  :: forall r r' l a
   . IsSymbol l
  => Cons l a r' r
  => Proxy l
  -> a
  -> Some r
  -> Some r
set p = setImpl (reflectSymbol p)

toObject :: forall r k. Homogeneous r k => Some r -> Object k
toObject = unsafeCoerce

foreign import modifyImpl :: forall r a. String -> (a -> a) -> Some r -> Some r

modify
  :: forall r r' l a
   . IsSymbol l
  => Cons l a r' r
  => Proxy l
  -> (a -> a)
  -> Some r
  -> Some r
modify p = modifyImpl (reflectSymbol p)

foreign import modifyOrSetImpl
  :: forall r a. String -> (a -> a) -> a -> Some r -> Some r

modifyOrSet
  :: forall r r' l a
   . IsSymbol l
  => Cons l a r' r
  => Proxy l
  -> (a -> a)
  -> a
  -> Some r
  -> Some r
modifyOrSet p = modifyOrSetImpl (reflectSymbol p)

some :: forall x y z. Union x y z => { | x } -> Some z
some = unsafeCoerce

instance recordWriteForeign ::
  ( RowToList row rl
  , WriteForeignFields rl row to
  ) =>
  JSON.WriteForeign (Some row) where
  writeImpl sm = unsafeToForeign $ writeImplFields (Proxy :: _ rl) sm (some {})

class
  WriteForeignFields (rl :: RowList Type) (row :: Row Type) (to :: Row Type)
  | rl -> row to where
  writeImplFields :: forall g. g rl -> Some row -> Some to -> Some to

instance consWriteForeignFields ::
  ( IsSymbol name
  , JSON.WriteForeign ty
  , WriteForeignFields tail row to
  , Row.Cons name ty whatever row
  , Row.Cons name Foreign to' to
  -- , Row.Lacks name to'
  ) =>
  WriteForeignFields (Cons name ty tail) row to where
  writeImplFields _ rec i = result
    where
    namep = Proxy :: Proxy name
    value = get namep rec
    tailp = Proxy :: Proxy tail
    result = writeImplFields tailp rec $ case value of
      Nothing -> i
      Just x -> set namep (JSON.writeImpl x) i

instance nilWriteForeignFields ::
  WriteForeignFields Nil row to where
  writeImplFields _ _ i = i

---

instance readRecord ::
  ( RowToList fields fieldList
  , ReadForeignFields fieldList fields
  ) =>
  JSON.ReadForeign (Some fields) where
  readImpl o = getFields fieldListP o (some {} :: Some fields)
    where
    fieldListP = Proxy :: Proxy fieldList

-- | A class for reading foreign values from properties
class
  ReadForeignFields (xs :: RowList Type) (to :: Row Type) where
  getFields
    :: Proxy xs
    -> Foreign
    -> Some to
    -> F (Some to)

foreign import hopHack :: String -> Foreign -> Boolean

instance readFieldsCons ::
  ( IsSymbol name
  , JSON.ReadForeign ty
  , ReadForeignFields tail to
  , Row.Cons name ty to' to
  -- , Row.Lacks name to'
  ) =>
  ReadForeignFields (Cons name ty tail) to where
  getFields _ obj sm = do
    let hp = hopHack name obj
    case hp of
      false -> getFields tailP obj sm
      true -> do
        let
          withExcept' = withExcept <<< map $ ErrorAtProperty name
        value <- withExcept' (JSON.readImpl =<< readProp name obj)
        getFields tailP obj (set nameP value sm)
    where
    nameP = Proxy :: Proxy name
    name = reflectSymbol nameP
    tailP = Proxy :: Proxy tail

exceptTApply
  :: forall a b e m
   . Semigroup e
  => Applicative m
  => ExceptT e m (a -> b)
  -> ExceptT e m a
  -> ExceptT e m b
exceptTApply fun a = ExceptT $ applyEither
  <$> runExceptT fun
  <*> runExceptT a

applyEither
  :: forall e a b. Semigroup e => Either e (a -> b) -> Either e a -> Either e b
applyEither (Left e) (Right _) = Left e
applyEither (Left e1) (Left e2) = Left (e1 <> e2)
applyEither (Right _) (Left e) = Left e
applyEither (Right fun) (Right a) = Right (fun a)

instance readFieldsNil ::
  ReadForeignFields Nil to where
  getFields _ _ sm = pure sm

instance JSON.WriteForeign (Some r) => Show (Some r) where
  show = JSON.writeJSON