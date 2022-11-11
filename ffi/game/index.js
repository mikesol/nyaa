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

// TODO: global audio context
const audioContext = new AudioContext();

export function startGameImpl(canvas, userId) {
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

    const scoreElement = document.getElementById("score");
    const judgmentElement = document.getElementById("judgment");
    const uiState = {
        score: 0,
        judgment: "",
        needsUpdate: false,
    };

    function updateUiState(score, judgment) {
        uiState.score = score;
        uiState.judgment = judgment;
        uiState.needsUpdate = true;
    }

    function animateUiState() {
        if (uiState.needsUpdate) {
            scoreElement.textContent = uiState.score.toString().padStart(8, "0");
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
            // if (elapsedTime >= audioElement.duration) {
            //     isFinished = true;
            // }
            cameraEffect.animate(elapsedTime, camera);
            // audioEffect.animate(elapsedTime);
            notes.animate(elapsedTime, 1.0);
            guides.animate(elapsedTime, 1.0);
            hits.animate(elapsedTime, 1.0);
        }
    }

    // SUBSECTION END - CORE

    // SUBSECTION START - AUDIO

    let beginTime = null;
    function startAudio() {
        if (audioContext.state === "suspended") {
            audioContext.resume();
            beginTime = audioContext.currentTime;
        } else {
            throw new Error("Already started...");
        }
    }

    // const audioElement = document.getElementsByName("audio");
    // let audioContext = null;
    // let audioTrack = null;
    // let beginTime = null;
    // let isFinished = false;
    // const context = {
    //     uThreshold: 1.0,
    //     togglePlayBack() {
    //         if (audioContext === null) {
    //             audioContext = new AudioContext();
    //             // audioTrack = audioContext.createMediaElementSource(audioElement);
    //             // audioEffect = new AudioEffect(audioContext, audioTrack);
    //             audioContext.resume()
    //             // audioElement.play();
    //             sendScore().then(() => {
    //                 console.log("[PubNub] Finished sending scores...");
    //             });
    //         }
    //         beginTime = audioContext.currentTime;
    //     }
    // };

    // gui.add(context, "uThreshold", 0.5, 1.0).name("uThreshold");
    // gui.add(context, "togglePlayBack").name("Toggle Playback");

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
                        updateUiState(score + 100, "Perfect");
                    } else if (judgment === "near") {
                        updateUiState(score + 100, "Near");
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
                    score: uiState.score,
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
            // TODO : SOMETHING HERE!
        }
    };
}
