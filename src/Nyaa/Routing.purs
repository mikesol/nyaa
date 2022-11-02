module Nyaa.Routing where

import Prelude

import Data.Generic.Rep (class Generic)
import Routing.Duplex (RouteDuplex', root)
import Routing.Duplex.Generic as G

data Route = Home

derive instance genericRoute :: Generic Route _

route :: RouteDuplex' Route
route = root $ G.sum
  { "Home": G.noArgs
  }