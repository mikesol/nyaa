import { startGameImpl } from "ffi-game";

export const startGame = (canvas) => (sub) => (userId) => (roomId) => (isHost) => (audioContext) => (audioBuffer) => (getTime) => () => {
    return startGameImpl(canvas, sub, userId, roomId, isHost, audioContext, audioBuffer, getTime);
}
