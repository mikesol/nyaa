"use strict";

import * as THREE from "three";
import { DEFAULT_cPlayerTerminal, guideTexture } from "./common.js";

function interpolate(value, r1, r2) {
    return (value - r1[0]) * (r2[1] - r2[0]) / (r1[1] - r1[0]) + r2[0];
}

const farFarAway = new THREE.Vector3(0.0, 0.0, 10.0);

export class Indicator {
    constructor(hits) {
        this.hits = hits;

        this.geometry = new THREE.PlaneGeometry(0.75, 0.75);
        this.material = new THREE.MeshBasicMaterial({
            opacity: 1.0,
            map: guideTexture,
            transparent: true,
        });
        this.mesh = new THREE.InstancedMesh(this.geometry, this.material, 4);

        this.matrices = [];
        for (let index = 0; index < 4; index++) {
            const matrix = new THREE.Matrix4();
            matrix.setPosition(farFarAway);
            this.mesh.setMatrixAt(index, matrix);
            this.matrices.push(matrix);
        }

        this.isOns = [false, false, false, false];
    }

    into(scene) {
        scene.add(this.mesh);
    }

    on(index) {
        this.isOns[index] = true;
    }

    off(index) {
        this.isOns[index] = false;
    }

    activate(_effect, _startTime, _duration, _offset) {
        return null;
    }

    animate(_elapsedTime, _noteThreshold) {
        for (const [index, isOn] of this.isOns.entries()) {
            if (isOn) {
                this.mesh.setMatrixAt(index, this.matrices[index].copy(this.hits.matrices[index]));
            } else {
                this.mesh.setMatrixAt(index, this.matrices[index].setPosition(farFarAway));
            }
        }
        this.mesh.instanceMatrix.needsUpdate = true;
    }

    destroy() {
        this.geometry.dispose();
        this.material.dispose();
        this.mesh.dispose();
    }
}