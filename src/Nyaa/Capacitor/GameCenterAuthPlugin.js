import { registerPlugin } from "@capacitor/core";

const GameCenterAuth = registerPlugin("GameCenterAuth");

export const signInWithGameCenter = async () => {
  const result = await GameCenterAuth.signIn();
  return result;
};
