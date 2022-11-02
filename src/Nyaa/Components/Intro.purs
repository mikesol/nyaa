module Nyaa.Components.Intro where

import Prelude

import Data.Foldable (oneOf)
import Deku.Attributes (klass_)
import Deku.Core (Domable)
import Deku.DOM as D
import Deku.Pursx (nut, (~~))
import Nyaa.Atoms.Buttons.Main (mainButton)
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

introScreen :: forall lock payload. Domable lock payload
introScreen = (Proxy :: Proxy IntroHTML) ~~
  { buttons: nut
      ( D.div (oneOf [ klass_ "flex justify-around" ])
          [ mainButton { text: "Play now!", click: pure unit }
          , mainButton { text: "Profile", click: pure unit }
          ]
      )
  }