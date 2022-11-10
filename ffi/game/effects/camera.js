"use strict";

function interpolate(value, r1, r2) {
    return (value - r1[0]) * (r2[1] - r2[0]) / (r1[1] - r1[0]) + r2[0];
}

class CameraEffect {
    constructor() {
        this.startTime = null;
        this.endTime = null;
        this.offset = null;
        this.isActive = false;
        this.isLeft = false;
        this.effectIndex = null;
        this.effects = [this.zoomAndRotate, this.skewSideways];
    }

    activate(startTime, duration, offset) {
        if (this.isActive) {
            return;
        }
        this.startTime = startTime;
        this.endTime = startTime + duration;
        this.offset = offset;
        this.isActive = true;
        this.isLeft = Math.random() < 0.5;
        this.effectIndex = Math.floor(Math.random() * 2);
    }

    animate(elapsedTime, camera) {
        if (!this.isActive) {
            return;
        }
        this.effects[this.effectIndex].call(this, elapsedTime, camera);
        if (elapsedTime >= this.endTime) {
            this.isActive = false;
        }
    }

    zoomAndRotate(elapsedTime, camera) {
        const { startTime, endTime, offset, isLeft } = this;
        const zRotationMax = isLeft ? -0.30 : 0.30;
        if (elapsedTime >= startTime && elapsedTime <= startTime + offset) {
            camera.rotation.z = interpolate(elapsedTime, [startTime, startTime + offset], [0.0, zRotationMax]);
            camera.position.z = interpolate(elapsedTime, [startTime, startTime + offset], [1.0, 1.30]);
        } else if (elapsedTime >= endTime - offset && elapsedTime <= endTime) {
            camera.rotation.z = interpolate(elapsedTime, [endTime - offset, endTime], [zRotationMax, 0.0]);
            camera.position.z = interpolate(elapsedTime, [endTime - offset, endTime], [1.30, 1.00]);
        }
    }

    skewSideways(elapsedTime, camera) {
        const { startTime, endTime, offset, isLeft } = this;
        const xPositionMax = isLeft ? -0.50 : 0.50;
        if (elapsedTime >= startTime && elapsedTime <= startTime + offset) {
            camera.position.x = interpolate(elapsedTime, [startTime, startTime + offset], [0.0, xPositionMax]);
            camera.position.z = interpolate(elapsedTime, [startTime, startTime + offset], [1.0, 1.30]);
        } else if (elapsedTime >= endTime - offset && elapsedTime <= endTime) {
            camera.position.x = interpolate(elapsedTime, [endTime - offset, endTime], [xPositionMax, 0.0]);
            camera.position.z = interpolate(elapsedTime, [endTime - offset, endTime], [1.30, 1.00]);
        }
    }
}

export const cameraEffect = new CameraEffect();
