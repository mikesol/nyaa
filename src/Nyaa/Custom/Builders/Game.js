import { startGameImpl } from "ffi-game";

//   successPath,
//   failurePath,
//   successCb,
//   failureCb,
export const startGame = i => () => {
    return startGameImpl(i);
}

export const currentTime = (ctx) => () => ctx.currentTime;