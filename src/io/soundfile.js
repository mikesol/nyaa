import halloweenUrl from "../../assets/halloween3.mp3";
import halloween3GUrl from "../../assets/mmm1.1.ffmpeg.v8.mp3";

export const getAudioData = () =>
  new Promise((resolve, reject) => {
    const request = new XMLHttpRequest();
    let myUrl = halloweenUrl;
    const connection = navigator.connection;
    if (connection && connection.effectiveType !== "4g") {
      myUrl = halloween3GUrl;
    }
    request.open("GET", myUrl, true);

    request.responseType = "arraybuffer";

    request.onload = () => {
      const audioData = request.response;
      resolve(audioData);
    };
    request.onerror = () => {
      reject("Could not download audio data");
    };

    request.send();
  });
