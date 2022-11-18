import { startGameImpl } from "ffi-game";

export const startGame = (canvas) => (subToEffects) => (pushBeginTime) => (myEffect) => (theirEffect) => (userId) => (roomId) => (isHost) => (audioContext) => (audioBuffer) => (getTime) => (noteInfo) => () => {
    return startGameImpl(canvas, subToEffects, pushBeginTime, myEffect, theirEffect, userId, roomId, isHost, audioContext, audioBuffer, getTime, noteInfo);
}

export const currentTime = (ctx) => () => ctx.currentTime;