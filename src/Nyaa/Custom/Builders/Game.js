import { startGameImpl } from "ffi-game";

export const startGame = (canvas) => (sub) => (userId) => (roomId) => (audioContext) => (audioBuffer) => (getTime) => () => {
    return startGameImpl(canvas, sub, userId, roomId, audioContext, audioBuffer, getTime);
}
