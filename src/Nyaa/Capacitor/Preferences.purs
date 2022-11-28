module Nyaa.Capacitor.Preferences where

import Prelude

import Control.Alt ((<|>))
import Control.Promise (Promise, toAffE)
import Data.Maybe (Maybe(..))
import Data.Symbol (class IsSymbol, reflectSymbol)
import Effect (Effect)
import Effect.Aff (Aff, ParAff, parallel, sequential)
import Nyaa.Some (Some, get, set, some, union)
import Prim.Row as Row
import Prim.RowList (class RowToList, Cons, Nil, RowList)
import Simple.JSON as JSON
import Type.Proxy (Proxy(..))

foreign import setPreference :: String -> String -> Effect (Promise Unit)

class SetPreferencesFromSome (rl :: RowList Type) r where
  setPreferencesFromSome' :: Proxy rl -> Some r -> ParAff Unit

instance
  ( IsSymbol key
  , Row.Cons key val whatever r
  , Row.Lacks key whatever
  , JSON.WriteForeign val
  , SetPreferencesFromSome rest r
  ) =>
  SetPreferencesFromSome (Cons key val rest) r where
  setPreferencesFromSome' _ s = setPreferencesFromSome' (Proxy :: _ rest) s <|>
    case get kpx s of
      Nothing -> pure unit
      Just y -> parallel $ toAffE $ setPreference (reflectSymbol kpx)
        (JSON.writeJSON y)
    where
    kpx = Proxy :: _ key

instance SetPreferencesFromSome Nil r where
  setPreferencesFromSome' _ _ = pure unit

setPreferencesFromSome
  :: forall r rl
   . RowToList r rl
  => SetPreferencesFromSome rl r
  => Some r
  -> Aff Unit
setPreferencesFromSome = sequential <<< setPreferencesFromSome' (Proxy :: _ rl)

class GetSomeFromPreferences (rl :: RowList Type) r where
  getSomeFromPreferences' :: Proxy rl -> ParAff (Some r)

instance
  ( IsSymbol key
  , Row.Cons key val whatever r
  , Row.Lacks key whatever
  , JSON.ReadForeign val
  , GetSomeFromPreferences rest r
  ) =>
  GetSomeFromPreferences (Cons key val rest) r where
  getSomeFromPreferences' _ =
    union
      <$>
        ( parPref <#> case _ of
            Nothing -> some {}
            Just y -> case JSON.readJSON_ y of
              Just y' -> set kpx y' (some {})
              Nothing -> some {}
        )
      <*> (getSomeFromPreferences' (Proxy :: _ rest))
    where
    kpx = Proxy :: _ key

    parPref :: ParAff (Maybe String)
    parPref = parallel $ toAffE (getPreference (reflectSymbol kpx))

instance GetSomeFromPreferences Nil r where
  getSomeFromPreferences' _ = pure (some {})

getSomeFromPreferneces
  :: forall r rl
   . RowToList r rl
  => GetSomeFromPreferences rl r
  => Proxy r
  -> Aff (Some r)
getSomeFromPreferneces _ = sequential (getSomeFromPreferences' (Proxy :: _ rl))

foreign import getPreferenceImpl
  :: (String -> Maybe String)
  -> Maybe String
  -> String
  -> Effect (Promise (Maybe String))

getPreference :: String -> Effect (Promise (Maybe String))
getPreference = getPreferenceImpl Just Nothing