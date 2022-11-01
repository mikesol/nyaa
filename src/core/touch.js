"use strict";

import {
  HIGHWAY_SCALE_X,
  HIGHWAY_SCALE_Y,
  RAIL_OFFSET,
  RAIL_ROTATION,
  RAIL_SCALE_X,
  RAIL_SCALE_Y,
} from "./plane";

import { BoxGeometry } from "three/src/geometries/BoxGeometry";
import { MeshBasicMaterial } from "three/src/materials/MeshBasicMaterial";
import { Mesh } from "three/src/objects/Mesh";

const three2 = {
  BoxGeometry,
  MeshBasicMaterial,
  Mesh,
};
export const LANE_TOUCH_AREA_SCALE_X = HIGHWAY_SCALE_X / 4;
export const LANE_TOUCH_AREA_SCALE_Y = HIGHWAY_SCALE_Y;
export const LANE_TOUCH_AREA_SCALE_Z = 0.5;
export const LANE_TOUCH_AREA_POSITION_Y = 0.0005;
export const LANE_TOUCH_AREA_POSITION_Z = 0.0;
export const LANE_TOUCH_AREA_GEOMETRY = new three2.BoxGeometry(
  LANE_TOUCH_AREA_SCALE_X,
  LANE_TOUCH_AREA_SCALE_Y,
  LANE_TOUCH_AREA_SCALE_Z
);
export const LANE_TOUCH_AREA_MATERIAL = new three2.MeshBasicMaterial({
  color: 0x111111,
});
export const LANE_TOUCH_AREA_COLUMN = {
  FAR_LEFT: -1.5,
  NEAR_LEFT: -0.5,
  NEAR_RIGHT: 0.5,
  FAR_RIGHT: 1.5,
};

export const createLaneTouchArea = (column) => {
  const mesh = new three2.Mesh(
    LANE_TOUCH_AREA_GEOMETRY,
    LANE_TOUCH_AREA_MATERIAL
  );
  mesh.position.set(
    LANE_TOUCH_AREA_SCALE_X * column,
    LANE_TOUCH_AREA_POSITION_Y,
    LANE_TOUCH_AREA_POSITION_Z
  );
  mesh.visible = false;
  return mesh;
};

export const RAIL_TOUCH_AREA_SCALE_X = RAIL_SCALE_X;
export const RAIL_TOUCH_AREA_SCALE_Y = RAIL_SCALE_Y;
export const RAIL_TOUCH_AREA_SCALE_Z = 0.5;
export const RAIL_TOUCH_AREA_POSITION_Z = 0.0;
export const RAIL_TOUCH_AREA_GEOMETRY = new three2.BoxGeometry(
  RAIL_TOUCH_AREA_SCALE_X,
  RAIL_TOUCH_AREA_SCALE_Y,
  RAIL_TOUCH_AREA_SCALE_Z
);
export const RAIL_TOUCH_AREA_MATERIAL = new three2.MeshBasicMaterial({
  color: 0x111111,
});
export const RAIL_TOUCH_AREA_COLUMN = {
  LEFT: -1,
  RIGHT: 1,
};

export const createRailTouchArea = (column) => {
  const mesh = new three2.Mesh(
    RAIL_TOUCH_AREA_GEOMETRY,
    RAIL_TOUCH_AREA_MATERIAL
  );
  mesh.rotation.set(0.0, 0.0, RAIL_ROTATION * column);
  mesh.position.set(
    (HIGHWAY_SCALE_X / 2 + RAIL_OFFSET - 0.0001) * column,
    RAIL_OFFSET + 0.0005,
    RAIL_TOUCH_AREA_POSITION_Z
  );
  mesh.visible = false;
  return mesh;
};
