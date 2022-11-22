import { startGameImpl } from "ffi-game";

export const startGame = (canvas) => (subToEffects) => (pushBeginTime) => (myEffect) => (theirEffect) => (userId) => (roomId) => (isHost) => (audioContext) => (audioBuffer) => (getTime) => (noteInfo) => (isTutorial) => (roomNumber) => () => {
    return startGameImpl(canvas, subToEffects, pushBeginTime, myEffect, theirEffect, userId, roomId, isHost, audioContext, audioBuffer, getTime, noteInfo, isTutorial, roomNumber);
}

export const currentTime = (ctx) => () => ctx.currentTime;