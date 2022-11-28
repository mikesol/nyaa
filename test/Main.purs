module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Nyaa.Some (Some, some)
import Simple.JSON as JSON
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual, shouldNotEqual)
import Test.Spec.Reporter (consoleReporter)
import Test.Spec.Runner (runSpec)


type SomeType = Some (foo :: Int, bar :: Int, baz :: String, hi :: Array Int )

main :: Effect Unit
main = do
  launchAff_
    $ runSpec [ consoleReporter ] do
        describe "Some" do
          it "should read and write to json correctly" $ liftEffect do
            let some1 = some {foo:1, bar: 3} :: SomeType
            let some2 = some {foo:1, bar: 3, baz: "a"} :: SomeType
            let some3 = some {foo:1, hi: [1,2,4]} :: SomeType
            JSON.readJSON (JSON.writeJSON some1) `shouldEqual` pure some1
            JSON.readJSON (JSON.writeJSON some2) `shouldEqual` pure some2
            JSON.readJSON (JSON.writeJSON some3) `shouldEqual` pure some3
            JSON.readJSON (JSON.writeJSON some1) `shouldNotEqual` pure some3
            JSON.writeJSON some3 `shouldEqual` "{\"foo\":1,\"hi\":[1,2,4]}"
