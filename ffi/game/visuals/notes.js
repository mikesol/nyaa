"use strict";

import * as THREE from "three";
import { activateCommon, animateCommon, DEFAULT_cNotesInitial, onBeforeCompileCommon } from "./common.js";
import noteImage from "assets/note.png";

const BEGIN_VERTEX = `
vRotation = radians(180.0);
vAlpha = 1.0;

int columnIndex = int(aIndex.y);

// effects change these values in particular
vec3 initial = cNotesInitial[columnIndex];
vec3 terminal = isPlayer() ? cPlayerTerminal[columnIndex] : cEnemyTerminal[columnIndex];

if (uEqualize.isActive && (columnIndex == 0 || columnIndex == 3)) {
    if (effectIsStarting(uEqualize)) {
        initial.y = interpolate(uTimeData.currentTime, uEqualize.startTime, uEqualize.startTime + uEqualize.offset, initial.y, initial.y - 0.25);
        terminal.y = interpolate(uTimeData.currentTime, uEqualize.startTime, uEqualize.startTime + uEqualize.offset, terminal.y, terminal.y - 0.25);
    } else if (effectIsRunning(uEqualize)) {
        initial.y = initial.y - 0.25;
        terminal.y = terminal.y - 0.25;
    } else if (effectIsEnding(uEqualize)) {
        initial.y = interpolate(uTimeData.currentTime, uEqualize.endTime - uEqualize.offset, uEqualize.endTime, initial.y - 0.25, initial.y);
        terminal.y = interpolate(uTimeData.currentTime, uEqualize.endTime - uEqualize.offset, uEqualize.endTime, terminal.y - 0.25, terminal.y);
    }
}

if (uRotate.isActive) {
    vRotation += radians(interpolate(uTimeData.currentTime, uRotate.startTime, uRotate.endTime, 0.0, 1080.0));
}

if (uDazzle.isActive) {
    initial.x += sin(radians(interpolate(uTimeData.currentTime, uDazzle.startTime, uDazzle.endTime, 0.0, 360.0)));
}

float noteThreshold = uTimeData.noteThreshold;
if (uGlide.isActive) {
    if (effectIsStarting(uGlide)) {
        noteThreshold = interpolate(uTimeData.currentTime, uGlide.startTime, uGlide.startTime + uGlide.offset, uTimeData.noteThreshold, 1.50);
    } else if (effectIsRunning(uGlide)) {
        noteThreshold = 1.50;
    } else if (effectIsEnding(uGlide)) {
        noteThreshold = interpolate(uTimeData.currentTime, uGlide.endTime - uGlide.offset, uGlide.endTime, 1.50, uTimeData.noteThreshold);
    }
}

if (uAmplify.isActive) {
    if (effectIsStarting(uAmplify))  {
        initial.y = interpolate(uTimeData.currentTime, uAmplify.startTime, uAmplify.startTime + uAmplify.offset, initial.y, initial.y + 1.00);
        initial.z = interpolate(uTimeData.currentTime, uAmplify.startTime, uAmplify.startTime + uAmplify.offset, initial.z, initial.z - 2.00);
    } else if (effectIsRunning(uAmplify)) {
        initial.y = initial.y + 1.00;
        initial.z = initial.z - 2.00;
    } else if (effectIsEnding(uAmplify)) {
        initial.y = interpolate(uTimeData.currentTime, uAmplify.endTime - uAmplify.offset, uAmplify.endTime, initial.y + 1.00, initial.y);
        initial.z = interpolate(uTimeData.currentTime, uAmplify.endTime - uAmplify.offset, uAmplify.endTime, initial.z - 2.00, initial.z);
    }
}

if (uReverse.isActive) {
    float terminalY = cPlayerTerminal[int(aIndex.y)].y;
    float terminalZ = cPlayerTerminal[int(aIndex.y)].z;

    if (effectIsStarting(uReverse))  {
        initial.y = interpolate(uTimeData.currentTime, uReverse.startTime, uReverse.startTime + uReverse.offset, initial.y, terminalY);
        initial.z = interpolate(uTimeData.currentTime, uReverse.startTime, uReverse.startTime + uReverse.offset, initial.z, terminalZ);
    } else if (effectIsRunning(uReverse)) {
        initial.y = terminalY;
        initial.z = terminalZ;
    } else if (effectIsEnding(uReverse)) {
        initial.y = interpolate(uTimeData.currentTime, uReverse.endTime - uReverse.offset, uReverse.endTime, terminalY, initial.y);
        initial.z = interpolate(uTimeData.currentTime, uReverse.endTime - uReverse.offset, uReverse.endTime, terminalZ, initial.z);
    }
}

if (uCompress.isActive) {
    float yMax = interpolate(0.10, 0.0, 1.0, terminal.y, cNotesInitial[columnIndex].y);
    float zMax = interpolate(0.10, 0.0, 1.0, terminal.z, cNotesInitial[columnIndex].z);
    if (effectIsStarting(uCompress)) {
        terminal.y = iEaseOutQuad(uTimeData.currentTime, uCompress.startTime, uCompress.startTime + uCompress.offset, terminal.y, yMax);
        terminal.z = iEaseOutQuad(uTimeData.currentTime, uCompress.startTime, uCompress.startTime + uCompress.offset, terminal.z, zMax);
    } else if (effectIsRunning(uCompress)) {
        terminal.y = yMax;
        terminal.z = zMax;
    } else if (effectIsEnding(uCompress)) {
        terminal.y = iEaseOutQuad(uTimeData.currentTime, uCompress.endTime - uCompress.offset, uCompress.endTime, yMax, terminal.y);
        terminal.z = iEaseOutQuad(uTimeData.currentTime, uCompress.endTime - uCompress.offset, uCompress.endTime, zMax, terminal.z);
    }
}

vec3 current = initial;
if (uTimeData.currentTime >= aTiming) {
    current.x = 0.0;
    current.y = 0.0;
    current.z = 5.0;
} else if (uTimeData.currentTime >= aTiming - noteThreshold) {
    current.x = interpolate(uTimeData.currentTime, aTiming - noteThreshold, aTiming, initial.x, terminal.x);
    current.y = interpolate(uTimeData.currentTime, aTiming - noteThreshold, aTiming, initial.y, terminal.y);
    current.z = interpolate(uTimeData.currentTime, aTiming - noteThreshold, aTiming, initial.z, terminal.z);
}

if (uHide.isActive) {
    float gapStart = isPlayer() ? -1.5 : 1.5;
    float gapEnd = isPlayer() ? -1.0 : 1.0;

    if (abs(current.z - terminal.z) <= abs(gapStart)) {
        float falseStart = interpolate(current.z, terminal.z + gapStart, terminal.z + gapEnd, 1.0, 0.0);
        if (effectIsStarting(uHide)) {
            vAlpha = interpolate(uTimeData.currentTime, uHide.startTime, uHide.startTime + uHide.offset, 1.0, falseStart);
        } else {
            vAlpha = falseStart;
        }
    }

    if (effectIsEnding(uHide)) {
        vAlpha = interpolate(uTimeData.currentTime, uHide.endTime - uHide.offset, uHide.endTime, vAlpha, 1.0);
    }
}

// effectively the output for 'begin_vertex'
vec3 transformed = current;
`;

const MAP_PARTICLE_FRAGMENT = `
#if defined( USE_MAP ) || defined( USE_ALPHAMAP )
    float mid = 0.5;
    vec2 uv = vec2(cos(vRotation) * (gl_PointCoord.x - mid) + sin(vRotation) * (gl_PointCoord.y - mid) + mid,
                   cos(vRotation) * (gl_PointCoord.y - mid) - sin(vRotation) * (gl_PointCoord.x - mid) + mid);
#endif

#ifdef USE_MAP
	diffuseColor *= texture2D(map, uv);
#endif

#ifdef USE_ALPHAMAP
	diffuseColor.a *= texture2D(alphaMap, uv).g;
#endif
`;

const OUTPUT_FRAGMENT = `
#include <output_fragment>
if (vAlpha == 0.0) discard;
gl_FragColor.a = vAlpha;
`;

export class Notes {
    constructor(notes) {
        const positions = new Float32Array(notes.length * 3 * 2);
        const aIndex = new Float32Array(notes.length * 2 * 2);
        const aTiming = new Float32Array(notes.length * 2 * 2);

        for (let index = 0; index < notes.length; index++) {
            const note = notes[index];
            const player_index = index;
            const enemy_index = notes.length + index;
            for (const [iAxis, sAxis] of ["x", "y", "z"].entries()) {
                const initialPosition = DEFAULT_cNotesInitial[note.column][sAxis];
                positions[player_index * 3 + iAxis] = initialPosition;
                positions[enemy_index * 3 + iAxis] = initialPosition;
            }
            aIndex[player_index * 2 + 0] = 1.0;
            aIndex[player_index * 2 + 1] = note.column;
            aIndex[enemy_index * 2 + 0] = 0.0;
            aIndex[enemy_index * 2 + 1] = note.column;
            aTiming[player_index] = note.timing;
            aTiming[enemy_index] = note.timing;
        }

        this.geometry = new THREE.BufferGeometry();
        this.geometry.setAttribute("position", new THREE.Float32BufferAttribute(positions, 3));
        this.geometry.setAttribute("aIndex", new THREE.Float32BufferAttribute(aIndex, 2));
        this.geometry.setAttribute("aTiming", new THREE.Float32BufferAttribute(aTiming, 1));

        this.material = new THREE.PointsMaterial({
            alphaTest: 1.0,
            map: new THREE.TextureLoader().load(noteImage),
            size: 0.50,
            sizeAttenuation: true,
            transparent: true,
        });

        this.material.onBeforeCompile = function (shader) {
            shader.vertexShader = shader.vertexShader.replace("#include <begin_vertex>", BEGIN_VERTEX);
            shader.fragmentShader = shader.fragmentShader.replace("#include <map_particle_fragment>", MAP_PARTICLE_FRAGMENT);
            shader.fragmentShader = shader.fragmentShader.replace("#include <output_fragment>", OUTPUT_FRAGMENT);
            onBeforeCompileCommon.call(this, shader);
        };

        this.mesh = new THREE.Points(this.geometry, this.material);
    }

    into(scene) {
        scene.add(this.mesh);
    }

    activate(effectId, startTime, duration, offset) {
        activateCommon.call(this, effectId, startTime, duration, offset);
    }

    animate(currentTime, noteThreshold) {
        animateCommon.call(this, currentTime, noteThreshold);
    }
}
