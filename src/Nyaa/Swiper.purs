module Nyaa.Swiper where

import Effect (Effect)
import Web.DOM (Element)

data Swiper

foreign import createSwiper :: Element -> Effect Swiper