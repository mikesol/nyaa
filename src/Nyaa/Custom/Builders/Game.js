import { startGameImpl } from "ffi-game";

export const startGame = (canvas) => (userId) => (roomId) => (audioContext) => (audioBuffer) => () => {
    return startGameImpl(canvas, userId, roomId, audioContext, audioBuffer);
}
