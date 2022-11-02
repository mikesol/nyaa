module Nyaa.Components.Intro where

import Prelude

import Data.Foldable (oneOf)
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toMaybe)
import Deku.Attributes (klass_)
import Deku.Control (switcher)
import Deku.Core (Domable)
import Deku.DOM as D
import Deku.Pursx ((~~))
import FRP.Event (Event)
import Nyaa.Atoms.Buttons.Main (mainButton)
import Nyaa.Firebase.Auth (User)
import Type.Proxy (Proxy(..))

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

introScreen
  :: forall lock payload
   . { authState :: Event { user :: Nullable User } }
  -> Domable lock payload
introScreen opts = (Proxy :: Proxy IntroHTML) ~~
  { buttons: D.div (oneOf [ klass_ "flex justify-around" ])
      [ mainButton { text: "Play now!", click: pure unit }
      , flip switcher opts.authState $ _.user >>> toMaybe >>> case _ of
          Nothing -> mainButton { text: "Sign In", click: pure unit }
          Just user -> mainButton { text: "Profile", click: pure unit }
      ]
  }