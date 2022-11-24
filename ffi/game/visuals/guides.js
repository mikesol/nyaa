"use strict";

import * as THREE from "three";
import { activateCommon, animateCommon, DEFAULT_cEnemyTerminal, DEFAULT_cPlayerTerminal, guideTexture, onBeforeCompileCommon } from "./common.js";

const BEGIN_VERTEX = `
vRotation = radians(0.0);
vAlpha = 1.0;

int columnIndex = int(aIndex.y);

vec3 current = isPlayer() ? cPlayerTerminal[columnIndex] : cEnemyTerminal[columnIndex];

if (uEqualize.isActive && (columnIndex == 0 || columnIndex == 3)) {
    if (effectIsStarting(uEqualize)) {
        current.y = interpolate(uTimeData.currentTime, uEqualize.startTime, uEqualize.startTime + uEqualize.offset, current.y, current.y - 0.25);
    } else if (effectIsRunning(uEqualize)) {
        current.y = current.y - 0.25;
    } else if (effectIsEnding(uEqualize)) {
        current.y = interpolate(uTimeData.currentTime, uEqualize.endTime - uEqualize.offset, uEqualize.endTime, current.y - 0.25, current.y);
    }
}

if (uCompress.isActive) {
    float yMax = interpolate(0.10, 0.0, 1.0, current.y, cNotesInitial[columnIndex].y);
    float zMax = interpolate(0.10, 0.0, 1.0, current.z, cNotesInitial[columnIndex].z);
    if (effectIsStarting(uCompress)) {
        current.y = iEaseOutQuad(uTimeData.currentTime, uCompress.startTime, uCompress.startTime + uCompress.offset, current.y, yMax);
        current.z = iEaseOutQuad(uTimeData.currentTime, uCompress.startTime, uCompress.startTime + uCompress.offset, current.z, zMax);
    } else if (effectIsRunning(uCompress)) {
        current.y = yMax;
        current.z = zMax;
    } else if (effectIsEnding(uCompress)) {
        current.y = iEaseOutQuad(uTimeData.currentTime, uCompress.endTime - uCompress.offset, uCompress.endTime, yMax, current.y);
        current.z = iEaseOutQuad(uTimeData.currentTime, uCompress.endTime - uCompress.offset, uCompress.endTime, zMax, current.z);
    }
}

// effectively the output for 'begin_vertex'
vec3 transformed = current;
`;

export class Guides {
    constructor() {
        const positions = new Float32Array(4 * 3 * 2);
        const aIndex = new Float32Array(4 * 2 * 2);

        for (let index = 0; index < 4; index++) {
            const player_index = index;
            const enemy_index = 4 + index;
            for (const [iAxis, sAxis] of ["x", "y", "z"].entries()) {
                positions[player_index * 3 + iAxis] = DEFAULT_cPlayerTerminal[index][sAxis];
                positions[enemy_index * 3 + iAxis] = DEFAULT_cEnemyTerminal[index][sAxis];
            }
            aIndex[player_index * 2 + 0] = 1.0;
            aIndex[player_index * 2 + 1] = index;
            aIndex[enemy_index * 2 + 0] = 0.0;
            aIndex[enemy_index * 2 + 1] = index;
        }

        this.geometry = new THREE.BufferGeometry();
        this.geometry.setAttribute("position", new THREE.Float32BufferAttribute(positions, 3));
        this.geometry.setAttribute("aIndex", new THREE.Float32BufferAttribute(aIndex, 2));

        this.material = new THREE.PointsMaterial({
            alphaTest: 1.0,
            map: guideTexture,
            size: 0.50,
            sizeAttenuation: true,
            transparent: true,
        });

        this.material.onBeforeCompile = function (shader) {
            shader.vertexShader = shader.vertexShader.replace("#include <begin_vertex>", BEGIN_VERTEX);
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

    destroy() {
        this.geometry.dispose();
        this.material.dispose();
    }
}
