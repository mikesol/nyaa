module Nyaa.Firebase.Firebase where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Foldable (for_, traverse_)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.Nullable (Nullable, toMaybe)
import Data.Symbol (class IsSymbol, reflectSymbol)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Ref as Ref
import Effect.Uncurried (EffectFn1)
import Nyaa.Capacitor.Preferences (getPreference)
import Nyaa.Some (Some)
import Prim.Row (class Cons)
import Type.Proxy (Proxy)
import Unsafe.Coerce (unsafeCoerce)

-- Auth
type User =
  { displayName :: Nullable String
  , email :: Nullable String
  , phoneNumber :: Nullable String
  , photoURL :: Nullable String
  , tenantId :: Nullable String
  , uid :: String
  }

newtype Ticket = Ticket
  { player1 :: String
  , player1Name :: String
  , player2 :: Maybe String
  , player2Name :: Maybe String
  }

foreign import gameCenterEagerAuth :: Effect (Promise Unit)
foreign import getCurrentUser :: Effect (Nullable User)
foreign import signInWithGameCenter :: Effect (Promise Unit)

foreign import signInWithPlayGames :: Effect (Promise Unit)

foreign import signInWithGoogle :: Effect (Promise Unit)
foreign import signOut :: Effect (Promise Unit)

foreign import listenToAuthStateChange
  :: EffectFn1 (Nullable User) Unit
  -> Effect (Effect Unit)

-- Firestore

type Profile' =
  ( avatarUrl :: String
  , username :: String
  , hasCompletedTutorial :: Boolean
  , track1 :: Boolean
  , flat :: Boolean
  , buzz :: Boolean
  , glide :: Boolean
  , back :: Boolean
  , track2 :: Boolean
  , rotate :: Boolean
  , hide :: Boolean
  , dazzle :: Boolean
  , track3 :: Boolean
  , crush :: Boolean
  , amplify :: Boolean
  , hasPaid :: Boolean
  , highScoreTrack1 :: Int
  , highScoreTrack2 :: Int
  , highScoreTrack3 :: Int
  )

newtype Profile = Profile (Some Profile')

derive instance Eq Profile
derive instance Newtype Profile _

foreign import getMeImpl
  :: (Profile -> Maybe Profile)
  -> (Maybe Profile)
  -> Effect (Promise (Maybe Profile))

getMe
  :: Effect (Promise (Maybe Profile))
getMe = getMeImpl Just Nothing

type CreateOrUpdateProfileAndInitializeListenerInput =
  { username :: Nullable String
  , avatarUrl :: Nullable String
  , hasCompletedTutorial :: Boolean
  , push :: EffectFn1 { profile :: Profile } Unit
  }

foreign import createOrUpdateProfileAndInitializeListener
  :: CreateOrUpdateProfileAndInitializeListenerInput
  -> Effect (Promise (Effect Unit))

reactToNewUser
  :: { push :: EffectFn1 { profile :: Profile } Unit
     , unsubProfileListener :: Ref.Ref (Effect Unit)
     , user :: Maybe User
     }
  -> Effect Unit
reactToNewUser { user, push, unsubProfileListener } = for_ user
  \usr -> launchAff_ do
    hct <- toAffE $ getPreference "hasCompletedTutorial"
    unsub <- toAffE $ createOrUpdateProfileAndInitializeListener
      { username: usr.displayName
      , avatarUrl: usr.photoURL
      , hasCompletedTutorial: hct == Just "true"
      , push
      }
    liftEffect $ Ref.write unsub unsubProfileListener

foreign import updateName :: { username :: String } -> Effect (Promise Unit)
foreign import genericUpdateImpl :: Profile -> Effect (Promise Unit)

foreign import updateViaTransactionImpl
  :: forall val. (val -> val) -> String -> Void -> Effect (Promise Unit)

updateViaTransaction
  :: forall key val r
   . IsSymbol key
  => Cons key val r Profile'
  => (Proxy key)
  -> (val -> val)
  -> val
  -> Effect (Promise Unit)
updateViaTransaction p f v = updateViaTransactionImpl f (reflectSymbol p)
  ((unsafeCoerce :: (val -> Void)) v)

genericUpdate :: Profile -> Effect (Promise Unit)
genericUpdate = genericUpdateImpl

foreign import updateAvatarUrl
  :: { avatarUrl :: String } -> Effect (Promise Unit)

foreign import uploadAvatar :: Uint8Array -> Effect (Promise String)

foreign import createTicketImpl
  :: Maybe String
  -> (String -> Maybe String)
  -> Int
  -> (Ticket -> Effect Unit)
  -> Effect (Promise (Effect Unit))

createTicket :: Int -> (Ticket -> Effect Unit) -> Effect (Promise (Effect Unit))
createTicket = createTicketImpl Nothing Just

foreign import cancelTicket :: Effect (Promise Unit)

foreign import logPageNavToAnalytics :: String -> Effect Unit
foreign import setUserId :: String -> Effect Unit

setUserIdFromUser :: User -> Effect Unit
setUserIdFromUser { uid } = setUserId uid

setUserIdFromMaybeUser :: Maybe User -> Effect Unit
setUserIdFromMaybeUser = traverse_ setUserIdFromUser

setUserIdFromNullableUser :: Nullable User -> Effect Unit
setUserIdFromNullableUser = toMaybe >>> setUserIdFromMaybeUser