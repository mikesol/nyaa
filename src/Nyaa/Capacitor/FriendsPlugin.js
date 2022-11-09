import { registerPlugin } from "@capacitor/core";

const Friends = registerPlugin("Friends");

export const sendFriendRequest = async () => {
    const result = await Friends.sendFriendRequest();
    return result;
  };
  
export const getFriends = async () => {
    const result = await Friends.getFriends();
    return result;
  };
  