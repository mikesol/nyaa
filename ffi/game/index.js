"use strict";

import * as THREE from "three";
import PubNub from "pubnub";

import { AudioEffect } from "./effects/audio.js";
import { Judge } from "./core/judge.js";
import { Notes } from "./visuals/notes.js";
import { CameraEffect } from "./effects/camera.js";
import { Guides } from "./visuals/guides.js";
import { Hits } from "./visuals/hits.js";
import { Reference } from "./visuals/reference.js";
import JSConfetti from "js-confetti";
import { Capacitor } from "@capacitor/core";

const jsConfetti = new JSConfetti();

async function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

// TODO: unhardcode
const BOT_EARLY = 0.2;
const BOT_PERFECT = 0.5;
const BOT_LATE = 0.7;
const EARLY_HIT = 0;
const PERFECT_HIT = 1;
const LATE_HIT = 2;
const NO_HIT = 3;
const LARGE_EPSILON = 0.15;
const SMALL_EPSILON = 0.05;

const choose = (choices) => {
  var index = Math.floor(Math.random() * choices.length);
  return choices[index];
};

export function startGameImpl({
  canvas,
  subToEffects,
  pushBeginTime,
  myEffect,
  theirEffect,
  userId,
  roomId,
  isHost,
  audioContext,
  audioBuffer,
  scoreToWin,
  getTime,
  noteInfo,
  roomNumber,
  successPath,
  failurePath,
  successCb,
  failureCb,
  showLeaderboard
}) {
  const isBot = roomId === "bot";
  if (audioContext.state !== "running") {
    console.log("Catastrophic failure!!!");
  }

  // SECTION START - THREE //

  const renderer = new THREE.WebGLRenderer({ canvas, antialias: true });
  const raycaster = new THREE.Raycaster();

  const camera = new THREE.PerspectiveCamera(
    90.0,
    canvas.clientWidth / canvas.clientHeight,
    0.1,
    10.0
  );
  camera.position.set(0.0, 0.65, 1.0);

  function tryResizeRendererToDisplay() {
    const canvas = renderer.domElement;
    const pixelRatio = window.devicePixelRatio;
    const width = (canvas.clientWidth * pixelRatio) | 0;
    const height = (canvas.clientHeight * pixelRatio) | 0;
    const needResize = canvas.width !== width || canvas.height !== height;
    if (needResize) {
      renderer.setSize(width, height, false);
      const canvas = renderer.domElement;
      camera.aspect = canvas.clientWidth / canvas.clientHeight;
      camera.updateProjectionMatrix();
    }
  }

  tryResizeRendererToDisplay();
  window.addEventListener("resize", tryResizeRendererToDisplay);

  // TODO: Make this an input instead...

  const scene = new THREE.Scene();

  const notes = new Notes(noteInfo);
  notes.into(scene);

  const guides = new Guides();
  guides.into(scene);

  const hits = new Hits();
  hits.into(scene);

  const reference = new Reference();
  reference.into(scene);

  // SUBSECTION START - UI

  const playerScoreElement = document.getElementById("score-player");
  const enemyScoreElement = document.getElementById("score-enemy");
  const judgmentElement = document.getElementById("judgment");
  const uiState = {
    didConfetti: false,
    playerScore: 0,
    enemyScore: 0,
    judgment: "",
    needsUpdate: false,
  };
  const perfectScore = 1_000_000 / noteInfo.length;
  const nearScore = perfectScore / 2;

  function animateUiState() {
    if (uiState.needsUpdate) {
      playerScoreElement.textContent = Math.floor(uiState.playerScore)
        .toString()
        .padStart(7, "0");
      enemyScoreElement.textContent = Math.floor(uiState.enemyScore)
        .toString()
        .padStart(7, "0");
      judgmentElement.textContent = uiState.judgment;
    }
    uiState.needsUpdate = false;
  }

  // SUBSECTION END - UI

  // SUBSECTION START - CORE

  let audioTrack = new AudioBufferSourceNode(audioContext, {
    buffer: audioBuffer,
  });
  let audioEffect = new AudioEffect(audioContext, audioTrack);
  const cameraEffect = new CameraEffect(camera);
  let isFinished = false;

  function animateCoreUi() {
    if (beginTime !== null) {
      const elapsedTime = audioContext.currentTime - beginTime;
      if (elapsedTime >= audioBuffer.duration) {
        isFinished = true;
      }
      cameraEffect.animate(elapsedTime, camera);
      audioEffect.animate(elapsedTime);
      notes.animate(elapsedTime, 1.0);
      guides.animate(elapsedTime, 1.0);
      hits.animate(elapsedTime, 1.0);
    }
  }

  // SUBSECTION END - CORE

  // SUBSECTION START - EFFECT RESPONDER
  const effectResponder = (msg) => {
    const { effect, startTime, duration, offset } = msg;
    if (effect === "camera") {
      cameraEffect.activate(startTime, duration, offset);
    } else if (effect === "audio") {
      audioEffect.activate(startTime, duration, offset);
    } else {
      notes.activate(effect, startTime, duration, offset);
      guides.activate(effect, startTime, duration, offset);
      hits.activate(effect, startTime, duration, offset);
    }
  };
  // SUBSECTION END - EFFECT RESPONDER

  // SUBSECTION START - BOT

  const doBotStuff = isBot
    ? (() => {
        let score = 0;
        const botNoteInfo = noteInfo.map((ni) => {
          const rn = Math.random();
          return {
            ...ni,
            hitInfo:
              rn < BOT_EARLY
                ? EARLY_HIT
                : rn < BOT_PERFECT
                ? PERFECT_HIT
                : rn < BOT_LATE
                ? LATE_HIT
                : NO_HIT,
          };
        });
        let t = 3.0;
        const effects = [];
        const effectEndTime = botNoteInfo[botNoteInfo.length - 1].timing - 10.0;
        while (t < effectEndTime) {
          t += Math.random() * 10.0;
          if (t > effectEndTime) {
            break;
          }
          const newbEffects = ["equalize", "camera", "glide", "compress"];
          const proEffects = [
            "equalize",
            "camera",
            "glide",
            "compress",
            "rotate",
            "dazzle",
            "hide",
          ];
          const deityEffects = [
            "equalize",
            "camera",
            "glide",
            "compress",
            "rotate",
            "dazzle",
            "hide",
            "audio",
            "amplify",
          ];
          effects.push({
            timing: t,
            effect:
              roomNumber === 1
                ? choose(newbEffects)
                : roomNumber === 2
                ? choose(proEffects)
                : choose(deityEffects),
          });
          t += 6.0; // hard-coded effect window. change?
        }

        return () => {
          const elapsedTime = audioContext.currentTime - beginTime;
          while (true) {
            if (!botNoteInfo[0]) {
              break;
            } else if (botNoteInfo[0].timing > elapsedTime + LARGE_EPSILON) {
              break;
            } else if (
              botNoteInfo[0].hitInfo === EARLY_HIT &&
              botNoteInfo[0].timing < elapsedTime + LARGE_EPSILON &&
              botNoteInfo[0].timing > elapsedTime + SMALL_EPSILON
            ) {
              score += nearScore;
              uiState.enemyScore = score.toString().padStart(7, "0");
              uiState.needsUpdate = true;
              botNoteInfo.shift();
            } else if (
              botNoteInfo[0].hitInfo === PERFECT_HIT &&
              botNoteInfo[0].timing < elapsedTime + SMALL_EPSILON &&
              botNoteInfo[0].timing > elapsedTime - SMALL_EPSILON
            ) {
              score += perfectScore;
              uiState.enemyScore = score.toString().padStart(7, "0");
              uiState.needsUpdate = true;
              botNoteInfo.shift();
            } else if (
              botNoteInfo[0].hitInfo === LATE_HIT &&
              botNoteInfo[0].timing < elapsedTime - SMALL_EPSILON &&
              botNoteInfo[0].timing > elapsedTime - LARGE_EPSILON
            ) {
              score += nearScore;
              uiState.enemyScore = score.toString().padStart(7, "0");
              uiState.needsUpdate = true;
              botNoteInfo.shift();
            } else {
              // programming error
              // shift and continue
              botNoteInfo.shift();
            }
          }
          while (true) {
            if (!effects[0]) {
              break;
            } else if (effects[0].timing > elapsedTime + SMALL_EPSILON) {
              break;
            } else {
              const msg = {
                effect: effects[0].effect,
                startTime: effects[0].timing,
                duration: 4.0, // todo: un-hard-code
                offset: 0.25, // todo: un-hard-code
              };
              theirEffect(msg)();
              effectResponder(msg);
              effects.shift();
            }
          }
        };
      })()
    : () => {};
  // SUBSECTION END - BOT

  // SUBSECTION START - AUDIO

  let beginTime = null;
  function startAudio() {
    audioTrack.start();
    audioTrack.addEventListener("ended", async () => {
      const alert = document.createElement("ion-alert");
      alert.backdropDismiss = false;
      const didWin = uiState.playerScore > scoreToWin;
      alert.header = didWin ? "Congrats!" : "Almost there!";
      alert.message = didWin
        ? "You've unlocked the next achievement. Keep going 😺"
        : "Your score wasn't high enough to unlock the next achievement 😿";
      // to do - this is a promise. do we care? def don't want to wait in case
      // reporting takes too long
      didWin ? successCb(uiState.playerScore)() : failureCb();

      const buttons = [];
      buttons.push({
        text: "Home",
        handler: () => {
          window.location.hash = "/";
        },
      });
      if (Capacitor.getPlatform() !== "web") {
        buttons.push({
          text: "View leaderboard",
          handler: () => {
            window.location.hash = successPath;
            // todo: this is a promise
            // do we care?
            showLeaderboard();
          },
        });
      }
      buttons.push(
        didWin
          ? {
              text: "Onwards",
              handler: () => {
                window.location.hash = successPath;
              },
            }
          : {
              text: "Try again",
              handler: () => {
                window.location.hash = failurePath;
              },
            }
      );
      alert.buttons = buttons;

      document.body.appendChild(alert);
      await alert.present();
    });
    beginTime = audioContext.currentTime;
    pushBeginTime(beginTime)();
  }

  // SUBSECTION END - AUDIO

  // SUBSECTION START - INPUT

  const judge = new Judge(noteInfo, audioBuffer.duration);
  const pointerBuffer = new THREE.Vector2();
  function handleTouch(event) {
    if (audioContext.state === "suspended") {
      return;
    }
    const elapsedTime = audioContext.currentTime - beginTime;
    for (const touch of event.changedTouches) {
      pointerBuffer.x = (touch.clientX / window.innerWidth) * 2 - 1;
      pointerBuffer.y = -(touch.clientY / window.innerHeight) * 2 + 1;
      raycaster.setFromCamera(pointerBuffer, camera);
      const intersects = hits.intersect(raycaster);
      if (intersects.length > 0) {
        const column = intersects[0].instanceId;
        judge.judge(elapsedTime, column, (judgment) => {
          if (judgment === "perfect") {
            uiState.playerScore += perfectScore;
            uiState.judgment = "Perfect";
            uiState.needsUpdate = true;
          } else if (judgment === "near") {
            uiState.playerScore += nearScore;
            uiState.judgment = "Near";
            uiState.needsUpdate = true;
          }
          if (uiState.playerScore > scoreToWin && !uiState.didConfetti) {
            uiState.didConfetti = true;
            jsConfetti.addConfetti();
          }
        });
      }
    }
  }
  document.documentElement.addEventListener("touchstart", handleTouch);

  // SUBSECTION END - INPUT

  // SECTION END - THREE //

  // SECTION START - PUBNUB or NOT //
  let unsubFromEffects = () => {};
  userId = `${userId}-${Math.random()}`;
  const pubnub = new PubNub({
    publishKey: "pub-c-494ce265-0510-4bb9-8871-5039406a833a",
    subscribeKey: "sub-c-829590e3-62e9-40a8-9354-b8161c2fbcd8",
    userId,
  });
  if (!isBot) {
    const monitorScore = async () => {
      let currentScore = latestScore;
      while (true) {
        if (isFinished) {
          return;
        }
        await sleep(5000);
        if (currentScore === latestScore) {
          onTimeout();
          return;
        } else {
          currentScore = latestScore;
        }
      }
    };

    let latestScore = null;

    const listener = {
      status: (statusEvent) => {
        if (statusEvent.operation === "PNSubscribeOperation") {
          console.log("[PubNub] Connected...");
        }
      },
      message: (messageEvent) => {
        console.log(messageEvent.publisher, userId);
        if (messageEvent.publisher === userId) {
          console.log("[PubNub] Ignoring message from self...");
          return;
        }
        if (
          audioContext.state === "suspended" &&
          (messageEvent.channel === `${roomId}-nyaa-score` ||
            messageEvent.channel === `${roomId}-nyaa-effect`)
        ) {
          console.log("[PubNub] Not ready...");
          return;
        }
        switch (messageEvent.channel) {
          case `${roomId}-nyaa-score`:
            {
              const { score } = messageEvent.message;
              uiState.enemyScore = score.toString().padStart(7, "0");
              uiState.needsUpdate = true;
              console.log(
                "Setting latest score",
                messageEvent.publisher,
                userId
              );
              console.log(roomId);
              latestScore = parseFloat(messageEvent.timetoken);
            }
            break;
          case `${roomId}-nyaa-effect`:
            {
              messageEvent.message.isHost === isHost
                ? myEffect(messageEvent.message)()
                : theirEffect(messageEvent.message)();
              effectResponder(messageEvent.message);
            }
            break;
          case `${roomId}-nyaa-info`:
            if (messageEvent.message.action === "start") {
              pubnub.publish({
                channel: `${roomId}-nyaa-info`,
                message: {
                  action: "ack1",
                  startTime: messageEvent.message.startTime,
                },
              });
            } else if (messageEvent.message.action === "ack1") {
              pubnub.publish({
                channel: `${roomId}-nyaa-info`,
                message: {
                  action: "ack2",
                  startTime: messageEvent.message.startTime,
                },
              });
              setTimeout(() => {
                startAudio();
                sendScore().then(() => {
                  console.log("[PubNub] Finished sending scores");
                });
                monitorScore().then(() => {
                  console.log("[PubNub] Finished monitoring scores");
                });
              }, messageEvent.message.startTime - getTime().time);
            } else if (messageEvent.message.action === "ack2") {
              setTimeout(() => {
                startAudio();
                sendScore().then(() => {
                  console.log("[PubNub] Finished sending scores");
                });
                monitorScore().then(() => {
                  console.log("[PubNub] Finished monitoring scores");
                });
              }, messageEvent.message.startTime - getTime().time);
            }
            break;
        }
      },
    };

    pubnub.addListener(listener);
    pubnub.subscribe({
      channels: [
        `${roomId}-nyaa-score`,
        `${roomId}-nyaa-effect`,
        `${roomId}-nyaa-info`,
      ],
    });

    const sendScore = async () => {
      while (true) {
        if (isFinished) {
          return;
        }
        await pubnub.publish({
          channel: `${roomId}-nyaa-score`,
          message: {
            score: uiState.playerScore,
          },
        });
        await sleep(1000);
      }
    };

    unsubFromEffects = subToEffects(({ fx, startTime, duration }) => () => {
      console.log("sending effect in normal mode");
      pubnub.publish({
        channel: `${roomId}-nyaa-effect`,
        message: {
          effect: fx,
          startTime: startTime + 1.0,
          duration,
          isHost,
          offset: 0.25,
        },
      });
    })();
  } else {
    unsubFromEffects = subToEffects((e) => () => {
      console.log("sending effect in tutorial mode");
      e.isHost === isHost ? myEffect(e)() : theirEffect(e)();
    })();
  }

  // SECTION END - PUBNUB //

  // SECTION START - TIMEOUT //

  async function onTimeout() {
    const alert = document.createElement("ion-alert");

    alert.header = "oh nyo, a timeout!?";
    alert.message =
      "Either you, or your opponent's connection timed out! This match will be exited...";
    alert.buttons = [
      {
        text: "Exit",
        handler: () => {
          window.location.href = "/#/";
        },
      },
    ];

    document.body.appendChild(alert);
    await alert.present();
  }

  // SECTION END - TIMEOUT

  function render() {
    animateUiState();
    animateCoreUi();
    doBotStuff();
    requestAnimationFrame(render);
    tryResizeRendererToDisplay();
    renderer.render(scene, camera);
  }

  return {
    start() {
      renderer.render(scene, camera);
      requestAnimationFrame(render);
      if (isBot) {
        setTimeout(() => {
          startAudio();
        }, 1000);
      }
      if (!isHost) {
        const currentTime = getTime().time;
        pubnub.publish({
          channel: `${roomId}-nyaa-info`,
          message: {
            action: "start",
            startTime: currentTime + 2500,
          },
        });
      }
    },
    kill() {
      isFinished = true;
      notes.destroy();
      guides.destroy();
      hits.destroy();
      reference.destroy();
      if (audioContext.state !== "closed") {
        audioTrack.stop();
        audioContext.suspend();  
      }
      pubnub.unsubscribeAll();
      unsubFromEffects();
    },
  };
}
