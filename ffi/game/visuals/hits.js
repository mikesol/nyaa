"use strict";

import * as THREE from "three";
import { activateCommon, DEFAULT_cPlayerTerminal } from "./common.js";

function interpolate(value, r1, r2) {
    return (value - r1[0]) * (r2[1] - r2[0]) / (r1[1] - r1[0]) + r2[0];
}

export class Hits {
    constructor() {
        this.geometry = new THREE.PlaneGeometry(0.75, 0.75);
        this.material = new THREE.MeshBasicMaterial({
            color: 0x00ff00,
            opacity: 0.5,
            transparent: true,
        });
        this.mesh = new THREE.InstancedMesh(this.geometry, this.material, 4);

        this.matrices = [];
        for (let index = 0; index < 4; index++) {
            const matrix = new THREE.Matrix4();
            matrix.setPosition(DEFAULT_cPlayerTerminal[index]);
            this.mesh.setMatrixAt(index, matrix);
            this.matrices.push(matrix);
        }

        this.equalize = {
            startTime: 0.0,
            endTime: 0.0,
            offset: 0.0,
            isActive: false,
        };

        this.mesh.visible = false;
    }

    into(scene) {
        scene.add(this.mesh);
    }

    activate(effectId, startTime, duration, offset) {
        if (effectId === "equalize") {
            if (this.equalize.isActive) {
                return;
            }
            this.equalize.startTime = startTime;
            this.equalize.endTime = startTime + duration;
            this.equalize.offset = offset;
            this.equalize.isActive = true;
        }
    }

    animate(currentTime, _) {
        this.animateEqualize(currentTime);
    }

    animateEqualize(currentTime) {
        if (!this.equalize.isActive) {
            return;
        }

        if (currentTime >= this.equalize.startTime && currentTime <= this.equalize.startTime + this.equalize.offset) {
            for (const index of [0, 3]) {
                const matrix = this.matrices[index];
                const cPlayerInitial = DEFAULT_cPlayerTerminal[index];
                matrix.setPosition(
                    cPlayerInitial.x,
                    interpolate(currentTime, [this.equalize.startTime, this.equalize.startTime + this.equalize.offset], [cPlayerInitial.y, cPlayerInitial.y - 0.25]),
                    cPlayerInitial.z,
                );
                this.mesh.setMatrixAt(index, matrix);
                this.mesh.instanceMatrix.needsUpdate = true;
            }
        } else if (currentTime >= this.equalize.startTime + this.equalize.offset && currentTime <= this.equalize.endTime - this.equalize.offset) {
            // do nothing...
        } else if (currentTime >= this.equalize.endTime - this.equalize.offset && currentTime <= this.equalize.endTime) {
            for (const index of [0, 3]) {
                const matrix = this.matrices[index];
                const cPlayerInitial = DEFAULT_cPlayerTerminal[index];
                matrix.setPosition(
                    cPlayerInitial.x,
                    interpolate(currentTime, [this.equalize.endTime - this.equalize.offset, this.equalize.endTime], [cPlayerInitial.y - 0.25, cPlayerInitial.y]),
                    cPlayerInitial.z,
                );
                this.mesh.setMatrixAt(index, matrix);
                this.mesh.instanceMatrix.needsUpdate = true;
            }
        }

        if (currentTime >= this.equalize.endTime) {
            this.equalize.isActive = false;
        }
    }

    intersect(raycaster) {
        return raycaster.intersectObject(this.mesh);
    }

    destroy() {
        this.geometry.dispose();
        this.material.dispose();
        this.mesh.dispose();
    }
}
