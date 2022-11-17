import { startGameImpl } from "ffi-game";

export const startGame = (canvas) => (subToEffects) => (pushBeginTime) => (userId) => (roomId) => (isHost) => (audioContext) => (audioBuffer) => (getTime) => () => {
    return startGameImpl(canvas, subToEffects, pushBeginTime, userId, roomId, isHost, audioContext, audioBuffer, getTime);
}

export const currentTime = (ctx) => () => ctx.currentTime;