import { startGameImpl } from "ffi-game";

export const startGame = (canvas) => (userId) => (roomId) => (isHost) => (audioContext) => (audioBuffer) => (getTime) => () => {
    return startGameImpl(canvas, userId, roomId, isHost, audioContext, audioBuffer, getTime);
}
