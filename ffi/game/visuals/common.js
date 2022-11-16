"use strict";

import * as THREE from "three";

export const COMMON_VERTEX_HEADERS = `
// Encodes effect data, such as when it begins and ends, an offset are
// ramped up and down to, and a flag which determines if they should
// occur.
struct EffectData {
    float startTime;
    float endTime;
    float offset;
    bool isActive;
};

// Encodes time data, such as the current time and the threshold in
// which notes should start moving.
struct TimeData {
    float currentTime;
    float noteThreshold;
};

// Attributes //

attribute vec2 aIndex;    // x = see isPlayer, y = note column (convert to int!!!)
attribute float aTiming;  // the timing of the note

// Uniforms //

uniform TimeData uTimeData;
uniform EffectData uEqualize;
uniform EffectData uRotate;
uniform EffectData uDazzle;
uniform EffectData uHide;
uniform EffectData uGlide;
uniform EffectData uAmplify;
uniform EffectData uReverse;
uniform EffectData uCompress;
uniform vec3 cNotesInitial[4];
uniform vec3 cPlayerTerminal[4];
uniform vec3 cEnemyTerminal[4];

// Varying //

varying float vRotation;  // for the rotation effect on notes
varying float vAlpha;     // for the 'hidden' effect on notes

// Functions //

bool isPlayer() {
    return aIndex.x > 0.5;  // weird, but I'll allow it xD
}

float interpolate(float value, float r1_0, float r1_1, float r2_0, float r2_1) {
    return (value - r1_0) * (r2_1 - r2_0) / (r1_1 - r1_0) + r2_0;  // the mitochondria, basically.
}

float easeOutQuad(float value) {
    return 1.0 - (1.0 - value) * (1.0 - value);
}

float iEaseOutQuad(float value, float r1_0, float r1_1, float r2_0, float r2_1) {
    value = interpolate(value, r1_0, r1_1, 0.0, 1.0);
    value = easeOutQuad(value);
    value = interpolate(value, 0.0, 1.0, r2_0, r2_1);
    return value;
}

bool effectIsStarting(EffectData effectData) {
    return uTimeData.currentTime >= effectData.startTime && uTimeData.currentTime <= effectData.startTime + effectData.offset;
}

bool effectIsRunning(EffectData effectData) {
    return uTimeData.currentTime >= effectData.startTime + effectData.offset && uTimeData.currentTime <= effectData.endTime - effectData.offset;
}

bool effectIsEnding(EffectData effectData) {
    return uTimeData.currentTime >= effectData.endTime - effectData.offset && uTimeData.currentTime <= effectData.endTime;
}
`;

export const COMMON_FRAGMENT_HEADERS = `
varying float vRotation;
varying float vAlpha;
`;

export const DEFAULT_cNotesInitial = [
    new THREE.Vector3(-1.5, 1.25, -2.0),
    new THREE.Vector3(-0.5, 1.00, -2.0),
    new THREE.Vector3(0.5, 1.00, -2.0),
    new THREE.Vector3(1.5, 1.25, -2.0),
];

export const DEFAULT_cPlayerTerminal = [
    new THREE.Vector3(-1.5, 0.25, 0.0),
    new THREE.Vector3(-0.5, 0.00, 0.0),
    new THREE.Vector3(0.5, 0.00, 0.0),
    new THREE.Vector3(1.5, 0.25, 0.0),
];

export const DEFAULT_cEnemyTerminal = [
    new THREE.Vector3(-1.5, 2.25, -4.0),
    new THREE.Vector3(-0.5, 2.00, -4.0),
    new THREE.Vector3(0.5, 2.00, -4.0),
    new THREE.Vector3(1.5, 2.25, -4.0),
];

export function onBeforeCompileCommon(shader) {
    shader.uniforms["uTimeData"] = {
        value: {
            currentTime: 0.0,
            noteThreshold: 0.0,
        },
    };
    for (const index of ["uTimeData", "uEqualize", "uRotate", "uDazzle", "uHide", "uGlide", "uAmplify", "uReverse", "uCompress"]) {
        shader.uniforms[index] = {
            value: {
                startTime: 0.0,
                endTime: 0.0,
                offset: 0.0,
                isActive: false,
            },
        };
    }
    shader.uniforms["cNotesInitial"] = {
        value: DEFAULT_cNotesInitial,
    };
    shader.uniforms["cPlayerTerminal"] = {
        value: DEFAULT_cPlayerTerminal,
    };
    shader.uniforms["cEnemyTerminal"] = {
        value: DEFAULT_cEnemyTerminal,
    }
    shader.vertexShader = COMMON_VERTEX_HEADERS + shader.vertexShader;
    shader.fragmentShader = COMMON_FRAGMENT_HEADERS + shader.fragmentShader;
    this.userData.shader = shader;
}

export function activateCommon(effectId, startTime, duration, offset) {
    const uniforms = this.mesh.material.userData.shader.uniforms;
    let effectData;
    // stringly-typed :O
    if (effectId === "equalize") {
        effectData = uniforms.uEqualize.value;
    } else if (effectId === "rotate") {
        effectData = uniforms.uRotate.value;
    } else if (effectId === "dazzle") {
        effectData = uniforms.uDazzle.value;
    } else if (effectId === "hide") {
        effectData = uniforms.uHide.value;
    } else if (effectId === "glide") {
        effectData = uniforms.uGlide.value;
    } else if (effectId === "amplify") {
        effectData = uniforms.uAmplify.value;
    } else if (effectId === "reverse") {
        effectData = uniforms.uReverse.value;
    } else if (effectId === "compress") {
        effectData = uniforms.uCompress.value;
    } else {
        throw new Error(`This is not a valid effect ${effectId}`);
    }
    if (effectData.isActive) {
        return;
    }
    effectData.startTime = startTime;
    effectData.endTime = startTime + duration;
    effectData.offset = offset;
    effectData.isActive = true;
}

export function animateCommon(currentTime, noteThreshold) {
    const uniforms = this.mesh.material.userData.shader.uniforms;
    const uTimeData = uniforms.uTimeData.value;
    uTimeData.currentTime = currentTime;
    uTimeData.noteThreshold = noteThreshold;
    for (const index of ["uEqualize", "uRotate", "uDazzle", "uHide", "uGlide", "uAmplify", "uReverse", "uCompress"]) {
        if (uniforms[index].value.isActive && currentTime >= uniforms[index].value.endTime) {
            uniforms[index].value.isActive = false;
        }
    }
}
