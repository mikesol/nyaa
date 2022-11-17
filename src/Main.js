export const prod = () => import.meta.env.PROD;
export const noStory = () => (import.meta.env.NO_STORY === "true");
