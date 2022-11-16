module Nyaa.Ionic.Custom where

import Prelude

import Data.Symbol (class IsSymbol, reflectSymbol)
import Deku.Core (Domable, fixed)
import Deku.Toplevel (runInElement')
import Effect (Effect)
import Prim.RowList (class RowToList)
import Prim.RowList as RL
import Type.Proxy (Proxy(..))
import Web.DOM.Element as Web.DOM

foreign import customComponentImpl :: forall local. String -> Array String -> (local -> Effect Unit) -> (local -> Effect Unit) -> (Web.DOM.Element -> local -> Effect (Effect Unit)) -> Effect Unit

class RL2Keys :: forall k. k -> Constraint
class RL2Keys rl where
  rl2Keys :: Proxy rl -> Array String

instance RL2Keys RL.Nil where
  rl2Keys _ = []

instance (IsSymbol key, RL2Keys rest) => RL2Keys (RL.Cons key String rest) where
  rl2Keys _ = [reflectSymbol (Proxy :: _ key)] <> rl2Keys (Proxy :: _ rest)

customComponent :: forall r rl. RowToList r rl => RL2Keys rl => String -> { | r } -> ({ | r } -> Effect Unit) -> ({ | r } -> Effect Unit) -> (forall lock payload. { | r } -> Array (Domable lock payload)) -> Effect Unit
customComponent s _ r k f = customComponentImpl s (rl2Keys (Proxy :: _ rl)) r k \e l ->
  runInElement' e (fixed (f l))

customComponent_ :: forall r rl. RowToList r rl => RL2Keys rl => String -> { | r } -> (forall lock payload. { | r } -> Array (Domable lock payload)) -> Effect Unit
customComponent_ s p f = customComponent s p (const $ pure unit) (const $ pure unit) f
