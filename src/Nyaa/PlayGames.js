import { registerPlugin } from "@capacitor/core";
//// setup
const PlayGames = registerPlugin("PlayGames");

export const submitScore = (values) => () => PlayGames.submitScore(values);
export const showLeaderboard = () => PlayGames.showLeaderboard();
export const unlockAchievement = (values) => () =>
  PlayGames.unlockAchievement(values);
export const incrementAchievement = (values) => () =>
  PlayGames.incrementAchievement(values);
export const getAchievements = (values) => () =>
  PlayGames.getAchievements(values);
export const showAchievements = () => PlayGames.getAchievements();
