import { startGameImpl } from "ffi-game";

export const startGame = (canvas) => (userId) => (roomId) => (audioContext) => (audioBuffer) => (getTime) => () => {
    return startGameImpl(canvas, userId, roomId, audioContext, audioBuffer, getTime);
}
