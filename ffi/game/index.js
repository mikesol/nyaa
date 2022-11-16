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

export function startGameImpl(canvas, userId, roomId, audioContext, audioBuffer) {
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
    const noteInfo = [];
    for (let column = 0, timing = 1.0; timing < 20.0; column = (column + 1) % 4, timing += 0.50) {
        noteInfo.push({ column, timing });
    }

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
            if (audioContext.state === "suspended") {
                console.log("[PubNub] Not ready...");
                return;
            }
            switch (messageEvent.channel) {
                case "nyaa-score":
                    const { score } = messageEvent.message;
                    uiState.enemyScore = score.toString().padStart(7, "0");
                    uiState.needsUpdate = true;
                    break;
                case "nyaa-effect":
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
                case "nyaa-info":
                    break;
            }
        },
    };

    pubnub.addListener(listener);
    pubnub.subscribe({
        channels: [
            "nyaa-score",
            "nyaa-effect",
            "nyaa-info",
        ],
    });

    const sendScore = async () => {
        while (true) {
            if (isFinished) {
                return;
            }
            await pubnub.publish({
                channel: "nyaa-score",
                message: {
                    score: uiState.playerScore,
                },
            });
            await sleep(1000);
        }
    };

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
            startAudio();
            sendScore().then(() => {
                console.log("[PubNub] Finished sending scores...");
            });
        },
        kill() {
            isFinished = true;
            notes.destroy();
            guides.destroy();
            hits.destroy();
            reference.destroy();
            audioTrack.stop();
            audioContext.suspend();
        }
    };
}
