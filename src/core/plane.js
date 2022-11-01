"use strict";

import { BoxGeometry } from "three/src/geometries/BoxGeometry";
import { MeshBasicMaterial } from "three/src/materials/MeshBasicMaterial";
import { Mesh } from "three/src/objects/Mesh";
import { Quaternion } from "three/src/math/Quaternion";
import { Vector3 } from "three/src/math/Vector3";
import { Matrix4 } from "three/src/math/Matrix4";
import { Euler } from "three/src/math/Euler";

const three2 = {
  BoxGeometry,
  MeshBasicMaterial,
  Mesh,
  Quaternion,
  Vector3,
  Matrix4,
  Euler,
};
export const MULTIPLIER_SCALE_X = 0.5;
export const MULTIPLIER_SCALE_Y = 0.001;
export const MULTIPLIER_SCALE_Z = 0.5;
export const MULTIPLIER_POSITION_X = 0.0;
export const MULTIPLIER_POSITION_Y = 0.0005;
export const MULTIPLIER_POSITION_Z = -1.0;
export const MULTIPLIER_GEOMETRY = () =>
  new three2.BoxGeometry(
    MULTIPLIER_SCALE_X,
    MULTIPLIER_SCALE_Y,
    MULTIPLIER_SCALE_Z
  );
export const MULTIPLIER_MATERIAL = ({ multtxt }) =>
  new three2.MeshBasicMaterial({
    color: 0xffffff,
    map: multtxt,
    transparent: true,
    alphaMap: multtxt,
  });

export const HIGHWAY_SCALE_X_BASE = 1.0;
export const HIGHWAY_SCALE_X_PADDING = 0.05;
export const HIGHWAY_SCALE_X = HIGHWAY_SCALE_X_BASE + HIGHWAY_SCALE_X_PADDING;
export const HIGHWAY_SCALE_Y = 0.001;
export const HIGHWAY_SCALE_Z = 5.0;
export const HIGHWAY_POSITION_X = 0.0;
export const HIGHWAY_POSITION_Y = 0.0;
export const HIGHWAY_POSITION_Z = -2.4;
export const HIGHWAY_GEOMETRY = () =>
  new three2.BoxGeometry(HIGHWAY_SCALE_X, HIGHWAY_SCALE_Y, HIGHWAY_SCALE_Z);
export const HIGHWAY_MATERIAL = () =>
  new three2.MeshBasicMaterial({
    color: 0x353436,
    transparent: true,
  });

export const createHighway = () => {
  const mesh = new three2.Mesh(HIGHWAY_GEOMETRY(), HIGHWAY_MATERIAL());
  mesh.position.set(HIGHWAY_POSITION_X, HIGHWAY_POSITION_Y, HIGHWAY_POSITION_Z);
  return mesh;
};

export const createMultiplier = ({ multtxt }) => {
  const mesh = new three2.Mesh(
    MULTIPLIER_GEOMETRY(),
    MULTIPLIER_MATERIAL({ multtxt })
  );
  mesh.position.set(
    MULTIPLIER_POSITION_X,
    MULTIPLIER_POSITION_Y,
    MULTIPLIER_POSITION_Z
  );
  return mesh;
};

export const JUDGE_SCALE_X = HIGHWAY_SCALE_X;
export const JUDGE_SCALE_Y = HIGHWAY_SCALE_Y;
export const JUDGE_SCALE_Z = 0.01;
export const JUDGE_POSITION_X = 0.0;
export const JUDGE_POSITION_Y = 0.003;
export const JUDGE_POSITION_Z = 0.0;
export const JUDGE_GEOMETRY = new three2.BoxGeometry(
  JUDGE_SCALE_X,
  JUDGE_SCALE_Y,
  JUDGE_SCALE_Z
);
export const JUDGE_MATERIAL = new three2.MeshBasicMaterial({ color: 0xffffff });

export const createJudge = () => {
  const mesh = new three2.Mesh(JUDGE_GEOMETRY, JUDGE_MATERIAL);
  mesh.position.set(JUDGE_POSITION_X, JUDGE_POSITION_Y, JUDGE_POSITION_Z);
  return mesh;
};

export const RAIL_SCALE_X_BASE = 0.2;
export const RAIL_SCALE_X_PADDING = 0.0125;
export const RAIL_SCALE_X = RAIL_SCALE_X_BASE + RAIL_SCALE_X_PADDING;
export const RAIL_SCALE_Y = HIGHWAY_SCALE_Y;
export const RAIL_SCALE_Z = HIGHWAY_SCALE_Z;
export const RAIL_POSITION_Z = HIGHWAY_POSITION_Z;
export const RAIL_OFFSET = RAIL_SCALE_X / 2 / Math.sqrt(2);
export const RAIL_ROTATION = (45 * Math.PI) / 180;
export const RAIL_CENTER_QUTERNION = new three2.Quaternion().setFromEuler(
  new three2.Euler(0.0, 0.0, -RAIL_ROTATION)
);
export const RAIL_SIDE_QUTERNION = new three2.Quaternion();
export const RAIL_CENTER_POSITION = new three2.Vector3(
  -HIGHWAY_SCALE_X / 2 - RAIL_OFFSET,
  RAIL_OFFSET,
  0.0
);
export const RAIL_SIDE_POSITION = new three2.Vector3(
  -HIGHWAY_SCALE_X / 2 - RAIL_SCALE_X / 2,
  0.0,
  0.0
);

export const RAIL_GEOMETRY = new three2.BoxGeometry(
  RAIL_SCALE_X,
  RAIL_SCALE_Y,
  RAIL_SCALE_Z
);
export const RAIL_MATERIAL = new three2.MeshBasicMaterial({ color: 0x4a4847 });

export const SIDES = {
  LEFT_SIDE: -42,
  CENTER: -41,
  RIGHT_SIDE: -40,
  LEFT_ON_DECK: -39,
  RIGHT_ON_DECK: -38,
  OFF_SCREEN: -35,
};

export const SIDES_CLOCKWISE = [
  SIDES.CENTER,
  SIDES.LEFT_SIDE,
  SIDES.LEFT_ON_DECK,
  SIDES.OFF_SCREEN,
  SIDES.OFF_SCREEN,
  SIDES.OFF_SCREEN,
  SIDES.RIGHT_ON_DECK,
  SIDES.RIGHT_SIDE,
];

export const createRails = () => {
  const mesh = new three2.Mesh(RAIL_GEOMETRY, RAIL_MATERIAL);

  const leftRailMatrix = new three2.Matrix4();
  leftRailMatrix.setPosition(new three2.Vector3(0.0, 0.0, RAIL_POSITION_Z));
  mesh.applyMatrix4(leftRailMatrix);

  return mesh;
};

export const RAIL_JUDGE_GEOMETRY = new three2.BoxGeometry(
  RAIL_SCALE_X,
  JUDGE_SCALE_Y,
  JUDGE_SCALE_Z
);
export const RAIL_JUDGE_MATERIAL = new three2.MeshBasicMaterial({
  color: 0xffffff,
});

export const createRailJudge = () => {
  const mesh = new three2.Mesh(RAIL_JUDGE_GEOMETRY, RAIL_JUDGE_MATERIAL);

  const leftRailJudgeMatrix = new three2.Matrix4();

  leftRailJudgeMatrix.setPosition(
    new three2.Vector3(0.0, 0.003, JUDGE_POSITION_Z)
  );
  mesh.applyMatrix4(leftRailJudgeMatrix);

  return mesh;
};

export const LANE_DIM_SCALE_X = HIGHWAY_SCALE_X_BASE / 4;
export const LANE_DIM_SCALE_Y = HIGHWAY_SCALE_Y;
export const LANE_DIM_SCALE_Z = HIGHWAY_SCALE_Z;
export const LANE_DIM_POSITION_Y = 0.0003;
export const LANE_DIM_POSITION_Z = HIGHWAY_POSITION_Z;
export const LANE_DIM_SPACE_BETWEEN = HIGHWAY_SCALE_X_PADDING / 5;
export const LANE_DIM_GEOMETRY = new three2.BoxGeometry(
  LANE_DIM_SCALE_X,
  LANE_DIM_SCALE_Y,
  LANE_DIM_SCALE_Z
);
export const LANE_DIM_MATERIAL = new three2.MeshBasicMaterial({
  color: 0xffffff,
  transparent: true,
  opacity: 0.2,
});

export const createLaneDim = (column) => {
  const mesh = new three2.Mesh(LANE_DIM_GEOMETRY, LANE_DIM_MATERIAL);
  mesh.position.set(
    (LANE_DIM_SCALE_X + LANE_DIM_SPACE_BETWEEN) * column,
    LANE_DIM_POSITION_Y,
    LANE_DIM_POSITION_Z
  );
  mesh.visible = false;
  return mesh;
};

export const RAIL_DIM_SCALE_X = RAIL_SCALE_X_BASE;
export const RAIL_DIM_SCALE_Y = RAIL_SCALE_Y;
export const RAIL_DIM_SCALE_Z = RAIL_SCALE_Z;
export const RAIL_DIM_GEOMETRY = new three2.BoxGeometry(
  RAIL_SCALE_X_BASE,
  RAIL_SCALE_Y,
  RAIL_SCALE_Z
);
export const RAIL_DIM_MATERIAL = new three2.MeshBasicMaterial({
  color: 0xffffff,
  transparent: true,
  opacity: 0.2,
});

export const createRailDim = (column) => {
  const mesh = new three2.Mesh(RAIL_DIM_GEOMETRY, RAIL_DIM_MATERIAL);
  mesh.rotation.set(0.0, 0.0, RAIL_ROTATION * column);
  mesh.position.set(
    (HIGHWAY_SCALE_X / 2 + RAIL_OFFSET - 0.0002) * column,
    RAIL_OFFSET + 0.0002,
    RAIL_POSITION_Z
  );
  mesh.visible = false;
  return mesh;
};

// middle is just identity matrix - no rotation, no translation, no scale
export const MIDDLE_M4 = new three2.Matrix4();
export const MIDDLE_POSITION = new three2.Vector3();
export const MIDDLE_QUATERNION = new three2.Quaternion();
export const MIDDLE_SCALE = new three2.Vector3();
MIDDLE_M4.decompose(MIDDLE_POSITION, MIDDLE_QUATERNION, MIDDLE_SCALE);

// other planes
export const LEFT_SIDE_M4 = (() => {
  const finalM4 = new three2.Matrix4();
  const rotationM4 = new three2.Matrix4().makeRotationZ(-RAIL_ROTATION);
  const translationM4 = new three2.Matrix4().makeTranslation(
    // start from the position
    HIGHWAY_POSITION_X -
      // subtract half the scale to move it to the edge
      HIGHWAY_SCALE_X / 2.0 -
      // subtract one side of the rail triangle
      RAIL_SCALE_X * Math.sin(Math.PI / 4.0) -
      // subtract the horizontal component of the width of the rotated figure
      // which uses half the base as the hypotenuse
      (HIGHWAY_SCALE_X * Math.sin(Math.PI / 4.0)) / 2.0,
    // add one side of the rail triangle
    RAIL_SCALE_X * Math.sin(Math.PI / 4.0) +
      // add the horizontal component of the width of the rotated figure
      // which uses half the base as the hypotenuse
      (HIGHWAY_SCALE_X * Math.sin(Math.PI / 4.0)) / 2.0,
    0.0
  );
  finalM4.multiplyMatrices(translationM4, rotationM4);
  return finalM4;
})();

export const LEFT_SIDE_POSITION = new three2.Vector3();
export const LEFT_SIDE_QUATERNION = new three2.Quaternion();
export const LEFT_SIDE_SCALE = new three2.Vector3();
LEFT_SIDE_M4.decompose(
  LEFT_SIDE_POSITION,
  LEFT_SIDE_QUATERNION,
  LEFT_SIDE_SCALE
);

export const RIGHT_SIDE_M4 = (() => {
  const finalM4 = new three2.Matrix4();
  const rotationM4 = new three2.Matrix4().makeRotationZ(RAIL_ROTATION);
  const translationM4 = new three2.Matrix4().makeTranslation(
    // start from the position
    HIGHWAY_POSITION_X +
      // add half the scale to move it to the edge
      HIGHWAY_SCALE_X / 2.0 +
      // add one side of the rail triangle
      RAIL_SCALE_X * Math.sin(Math.PI / 4.0) +
      // add the horizontal component of the width of the rotated figure
      // which uses half the base as the hypotenuse
      (HIGHWAY_SCALE_X * Math.sin(Math.PI / 4.0)) / 2.0,
    // add one side of the rail triangle
    RAIL_SCALE_X * Math.sin(Math.PI / 4.0) +
      // add the horizontal component of the width of the rotated figure
      // which uses half the base as the hypotenuse
      (HIGHWAY_SCALE_X * Math.sin(Math.PI / 4.0)) / 2.0,
    0.0
  );
  finalM4.multiplyMatrices(translationM4, rotationM4);
  return finalM4;
})();

export const RIGHT_SIDE_POSITION = new three2.Vector3();
export const RIGHT_SIDE_QUATERNION = new three2.Quaternion();
export const RIGHT_SIDE_SCALE = new three2.Vector3();
RIGHT_SIDE_M4.decompose(
  RIGHT_SIDE_POSITION,
  RIGHT_SIDE_QUATERNION,
  RIGHT_SIDE_SCALE
);

export const LEFT_ON_DECK_M4 = (() => {
  const finalM4 = new three2.Matrix4();
  const rotationM4 = new three2.Matrix4().makeRotationZ(-RAIL_ROTATION);
  const translationM4 = new three2.Matrix4().makeTranslation(
    // start from the position
    HIGHWAY_POSITION_X -
      // subtract half the scale to move it to the edge
      HIGHWAY_SCALE_X / 2.0 -
      // subtract one side of the rail triangle
      RAIL_SCALE_X * Math.sin(Math.PI / 4.0) -
      // subtract the full currently-visible lane
      HIGHWAY_SCALE_X * Math.sin(Math.PI / 4.0) -
      // subtract the full currently-visible rail
      RAIL_SCALE_X * Math.sin(Math.PI / 4.0) -
      // subtract the horizontal component of the width of the rotated figure
      // which uses half the base as the hypotenuse
      (HIGHWAY_SCALE_X * Math.sin(Math.PI / 4.0)) / 2.0,
    // add one side of the rail triangle
    RAIL_SCALE_X * Math.sin(Math.PI / 4.0) +
      // add the full currently-visible lane
      HIGHWAY_SCALE_X * Math.sin(Math.PI / 4.0) +
      // add the full currently-visible rail
      RAIL_SCALE_X * Math.sin(Math.PI / 4.0) +
      // add the horizontal component of the width of the rotated figure
      // which uses half the base as the hypotenuse
      (HIGHWAY_SCALE_X * Math.sin(Math.PI / 4.0)) / 2.0,
    0.0
  );
  finalM4.multiplyMatrices(translationM4, rotationM4);
  return finalM4;
})();
export const LEFT_ON_DECK_POSITION = new three2.Vector3();
export const LEFT_ON_DECK_QUATERNION = new three2.Quaternion();
export const LEFT_ON_DECK_SCALE = new three2.Vector3();
LEFT_ON_DECK_M4.decompose(
  LEFT_ON_DECK_POSITION,
  LEFT_ON_DECK_QUATERNION,
  LEFT_ON_DECK_SCALE
);

export const RIGHT_ON_DECK_M4 = (() => {
  const finalM4 = new three2.Matrix4();
  const rotationM4 = new three2.Matrix4().makeRotationZ(RAIL_ROTATION);
  const translationM4 = new three2.Matrix4().makeTranslation(
    // start from the position
    HIGHWAY_POSITION_X +
      // subtract half the scale to move it to the edge
      HIGHWAY_SCALE_X / 2.0 +
      // subtract one side of the rail triangle
      RAIL_SCALE_X * Math.sin(Math.PI / 4.0) +
      // subtract the full currently-visible lane
      HIGHWAY_SCALE_X * Math.sin(Math.PI / 4.0) +
      // subtract the full currently-visible rail
      RAIL_SCALE_X * Math.sin(Math.PI / 4.0) +
      // subtract the horizontal component of the width of the rotated figure
      // which uses half the base as the hypotenuse
      (HIGHWAY_SCALE_X * Math.sin(Math.PI / 4.0)) / 2.0,
    // add one side of the rail triangle
    RAIL_SCALE_X * Math.sin(Math.PI / 4.0) +
      // add the full currently-visible lane
      HIGHWAY_SCALE_X * Math.sin(Math.PI / 4.0) +
      // add the full currently-visible rail
      RAIL_SCALE_X * Math.sin(Math.PI / 4.0) +
      // add the horizontal component of the width of the rotated figure
      // which uses half the base as the hypotenuse
      (HIGHWAY_SCALE_X * Math.sin(Math.PI / 4.0)) / 2.0,
    0.0
  );
  finalM4.multiplyMatrices(translationM4, rotationM4);
  return finalM4;
})();
export const RIGHT_ON_DECK_POSITION = new three2.Vector3();
export const RIGHT_ON_DECK_QUATERNION = new three2.Quaternion();
export const RIGHT_ON_DECK_SCALE = new three2.Vector3();
RIGHT_ON_DECK_M4.decompose(
  RIGHT_ON_DECK_POSITION,
  RIGHT_ON_DECK_QUATERNION,
  RIGHT_ON_DECK_SCALE
);

export const OFF_SCREEN_M4 = (() => {
  const finalM4 = new three2.Matrix4().makeTranslation(100.0, 100.0, 100.0);
  return finalM4;
})();

// opacity for side lanes
export const SIDE_LANE_OPACITY = 0.5;
