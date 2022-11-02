module Nyaa.Components.Intro where


import Deku.Core (Domable)
import Deku.Pursx ((~~))
import Type.Proxy (Proxy(..))

type IntroHTML = """
<div class="bg-splash absolute w-screen h-screen grid grid-cols-1 grid-rows-1">
  <div class="col-start-1 col-span-1 row-start-1 row-span-1 place-self-center">
    <div class="font-fillmein text-center text-white text-4xl">
      Nyaa
    </div>
    <div class="flex justify-around">
      <button
        class="text-gray-900 bg-gradient-to-r from-red-200 via-red-300 to-yellow-200 hover:bg-gradient-to-bl focus:ring-4 focus:outline-none focus:ring-red-100 dark:focus:ring-red-400 font-medium rounded-lg text-lg px-5 py-2.5 text-center mr-2 mb-2">
        Play Now!
      </button>
    </div>
  </div>
</div>
"""

introScreen :: forall lock payload. Domable lock payload
introScreen = (Proxy :: Proxy IntroHTML) ~~ {}