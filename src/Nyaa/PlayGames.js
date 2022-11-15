import { registerPlugin } from "@capacitor/core";
//// setup
const PlayGames = registerPlugin("PlayGames");

export const submitScore = (values) => () => PlayGames.submitScore(values);
export const showLeaderboard = (values) => () => PlayGames.showLeaderboard(values);
export const unlockAchievement = (values) => () =>
  PlayGames.unlockAchievement(values);
export const incrementAchievement = (values) => () =>
  PlayGames.incrementAchievement(values);
export const getAchievements = () =>
  PlayGames.getAchievements();
export const showAchievements = () => PlayGames.getAchievements();
