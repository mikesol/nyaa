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

async function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

export function startGameImpl(
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
    getTime,
    noteInfo
  ) {
    console.log(isHost);
    // SECTION START - THREE //

    const renderer = new THREE.WebGLRenderer({ canvas, antialias: true });
    const raycaster = new THREE.Raycaster();

    const camera = new THREE.PerspectiveCamera(90.0, canvas.clientWidth / canvas.clientHeight, 0.1, 10.0);
    camera.position.set(0.0, 0.65, 1.0);

    function tryResizeRendererToDisplay() {
        const canvas = renderer.domElement;
        const pixelRatio = window.devicePixelRatio;
        const width = canvas.clientWidth * pixelRatio | 0;
        const height = canvas.clientHeight * pixelRatio | 0;
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
        playerScore: 0,
        enemyScore: 0,
        judgment: "",
        needsUpdate: false,
    };

    function animateUiState() {
        if (uiState.needsUpdate) {
            playerScoreElement.textContent = uiState.playerScore.toString().padStart(7, "0");
            enemyScoreElement.textContent = uiState.enemyScore.toString().padStart(7, "0");
            judgmentElement.textContent = uiState.judgment;
        }
        uiState.needsUpdate = false;
    }

    // SUBSECTION END - UI

    // SUBSECTION START - CORE

    let audioEffect = null;  // Filled in later..
    const cameraEffect = new CameraEffect(camera);
    let isFinished = false;

    function animateCoreUi() {
        if (audioContext.state === "running") {
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

    // SUBSECTION START - AUDIO

    let audioTrack = null;
    let beginTime = null;

    function startAudio() {
        if (audioContext.state === "suspended") {
            audioTrack = new AudioBufferSourceNode(audioContext, { buffer: audioBuffer });
            audioEffect = new AudioEffect(audioContext, audioTrack);
            audioContext.resume();
            audioTrack.start();
            beginTime = audioContext.currentTime;
            pushBeginTime(beginTime)();
        } else {
            throw new Error("Already started...");
        }
    }

    // SUBSECTION END - AUDIO

    // SUBSECTION START - INPUT

    const judge = new Judge(noteInfo, 20);
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
                        uiState.playerScore += 10;
                        uiState.judgment = "Perfect";
                        uiState.needsUpdate = true;
                    } else if (judgment === "near") {
                        uiState.playerScore += 50;
                        uiState.judgment = "Near";
                        uiState.needsUpdate = true;
                    }
                });
            }
        }
    }
    document.documentElement.addEventListener("touchstart", handleTouch);

    // SUBSECTION END - INPUT

    // SECTION END - THREE //

    // SECTION START - PUBNUB //

    userId = `${userId}-${Math.random()}`;

    const pubnub = new PubNub({
        publishKey: "pub-c-494ce265-0510-4bb9-8871-5039406a833a",
        subscribeKey: "sub-c-829590e3-62e9-40a8-9354-b8161c2fbcd8",
        userId,
    });

    const listener = {
        status: (statusEvent) => {
            if (statusEvent.operation === "PNSubscribeOperation") {
                console.log("[PubNub] Connected...");
            }
        },
        message: (messageEvent) => {
            if (messageEvent.publisher === userId) {
                console.log("[PubNub] Ignoring message from self...");
                return;
            }
            if ( audioContext.state === "suspended"
                 && ( messageEvent.channel === `${roomId}-nyaa-score`
                      || messageEvent.channel === `${roomId}-nyaa-effect`
                    )
               ) {
                console.log("[PubNub] Not ready...");
                return;
            }
            switch (messageEvent.channel) {
                case `${roomId}-nyaa-score`:
                    const { score } = messageEvent.message;
                    uiState.enemyScore = score.toString().padStart(7, "0");
                    uiState.needsUpdate = true;
                    break;
                case `${roomId}-nyaa-effect`:
                    messageEvent.message.isHost === isHost ? myEffect(messageEvent.message)() : theirEffect(messageEvent.message)();
                    const { effect, startTime, duration, offset } = messageEvent.message;
                    if (effect === "camera") {
                        cameraEffect.activate(startTime, duration, offset);
                    } else if (effect === "audio") {
                        audioEffect.activate(startTime, duration, offset);
                    } else {
                        notes.activate(effect, startTime, duration, offset);
                        guides.activate(effect, startTime, duration, offset);
                        hits.activate(effect, startTime, duration, offset);
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
                        }, messageEvent.message.startTime - getTime().time);
                    } else if (messageEvent.message.action === "ack2") {
                        setTimeout(() => {
                            startAudio();
                            sendScore().then(() => {
                                console.log("[PubNub] Finished sending scores");
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

    const unsubFromEffects = subToEffects(({ fx, startTime, duration }) => () => {
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

    // SECTION END - PUBNUB //

    function render() {
        animateUiState();
        animateCoreUi();
        requestAnimationFrame(render);
        tryResizeRendererToDisplay();
        renderer.render(scene, camera);
    }

    return {
        start() {
            renderer.render(scene, camera);
            requestAnimationFrame(render);
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
            audioTrack.stop();
            audioContext.suspend();
            pubnub.unsubscribeAll();
            unsubFromEffects();
        }
    };
}
