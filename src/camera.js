"use strict";

import { PerspectiveCamera } from "three/src/cameras/PerspectiveCamera";

const three2 = { PerspectiveCamera }

const CAMERA_X_POSITION = 0.00;
const CAMERA_Y_POSITION = 0.50;
const CAMERA_Z_POSITION = 0.10;

const CAMERA_X_ROTATION = -0.75;
const CAMERA_Y_ROTATION = 0.00;
const CAMERA_Z_ROTATION = 0.00;

const CAMERA_FOV = 90.00;
const CAMERA_NEAR = 0.10;
const CAMERA_FAR = 10.00;

export const createCamera = (aspect) => {
    const camera = new three2.PerspectiveCamera(CAMERA_FOV, aspect, CAMERA_NEAR, CAMERA_FAR);
    camera.position.set(CAMERA_X_POSITION, CAMERA_Y_POSITION, CAMERA_Z_POSITION);
    camera.rotation.set(CAMERA_X_ROTATION, CAMERA_Y_ROTATION, CAMERA_Z_ROTATION);
    return camera;
}
