module Nyaa.Components.Intro where

import Prelude

import Control.Promise (toAffE)
import Data.Foldable (oneOf)
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toMaybe)
import Deku.Attributes (klass_)
import Deku.Control (switcher)
import Deku.Core (Domable, fixed)
import Deku.DOM as D
import Deku.Pursx ((~~))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import FRP.Event (Event)
import Nyaa.Assets (testURL)
import Nyaa.Atoms.Buttons.Main (mainButton)
import Nyaa.Capacitor.GameCenterAuthPlugin (signInWithGameCenter)
import Nyaa.Capacitor.Utils (Platform(..), getPlatform)
import Nyaa.Firebase.Auth (User, signInWithApple, signInWithGoogle, signInWithPlayGames, signOut)
import Ocarina.Control (gain_, playBuf, sinOsc)
import Ocarina.Core (bangOn)
import Ocarina.Interpret (constant0Hack_, context_, decodeAudioDataFromUri)
import Ocarina.Run (run2)
import Type.Proxy (Proxy(..))

signInFlow :: Effect Unit
signInFlow = do
  platform <- getPlatform
  launchAff_ do
    case platform of
      Web -> void $ toAffE signInWithGoogle
      IOS -> void $ toAffE signInWithGameCenter
      Android -> void $ toAffE signInWithPlayGames

signOutFlow :: Effect Unit
signOutFlow = launchAff_ $ toAffE signOut

audioTest :: Effect Unit
audioTest = do
  ctx <- context_
  usu1 <- constant0Hack_ ctx
  launchAff_ do
    buf <- decodeAudioDataFromUri ctx testURL
    liftEffect do
      usu2 <- run2 ctx [ gain_ 0.2 [ playBuf buf bangOn ] ]
      pure unit

introScreen
  :: forall lock payload
   . { authState :: Event { user :: Nullable User } }
  -> Domable lock payload
introScreen opts = (Proxy :: Proxy IntroHTML) ~~
  { buttons: D.div (oneOf [ klass_ "flex justify-around" ])
      [ mainButton { text: "Play now!", click: pure unit }
      , flip switcher opts.authState $ _.user >>> toMaybe >>> case _ of
          Nothing -> fixed [ mainButton { text: "Sign In", click: signInFlow }, mainButton { text: "Audio test", click: audioTest } ]
          Just user -> fixed
            [ mainButton { text: "Profile", click: pure unit }
            , mainButton { text: "Sign Out", click: signOutFlow }
            ]
      ]
  }

type IntroHTML =
  """
<div class="bg-spacecat absolute w-screen h-screen grid grid-cols-1 grid-rows-1">
  <div class="col-start-1 col-span-1 row-start-1 row-span-1 place-self-center">
    <div class="font-fillmein text-center text-white p-4 text-4xl">
      Nyaa
    </div>
    ~buttons~
  </div>
</div>
"""

