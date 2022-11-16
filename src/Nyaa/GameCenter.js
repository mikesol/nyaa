import { registerPlugin } from "@capacitor/core";
//// setup
const GameCenter = registerPlugin("GameCenter");

export const showAccessPoint = (values) => () =>
  GameCenter.showAccessPoint(values);
export const hideAccessPoint = () => GameCenter.hideAccessPoint();
export const showGameCenter = (values) => () =>
  GameCenter.showGameCenter(values);
export const getLeaderboard = (values) => () =>
  GameCenter.getLeaderboard(values);
export const submitScore = (values) => () => GameCenter.submitScore(values);
export const getAchievements = () =>
  GameCenter.getAchievements();
export const reportAchievements = (values) => () =>
  GameCenter.reportAchievements(values);
