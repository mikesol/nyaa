"use strict"

export const newAudioContext = () => {
    return new AudioContext();
};

export const resume = (ctx) => () => {
    return ctx.resume()
}