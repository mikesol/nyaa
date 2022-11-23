"use strict";

import Swiper, { Mousewheel, Navigation } from "swiper";

export const createSwiper = (element) => () => {
    return new Swiper(element, {
        modules: [Mousewheel, Navigation],
        mousewheel: true,
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
            hideOnClick: true,
          },
    });
}