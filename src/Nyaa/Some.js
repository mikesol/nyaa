export const getImpl = (just) => (nothing) => (key) => (rec) =>
  rec[key] === undefined ? nothing : just(rec[key]);

export const setImpl = (key) => (val) => (rec) => {
  const o = { ...rec };
  o[key] = val;
  return o;
};

export const hopHack = (k) => (v) => k in v;

export const modifyImpl = (key) => (f) => (rec) => {
  const o = { ...rec };
  const rk = rec[key];
  if (rk !== undefined) {
    o[key] = f(rec[key]);
  }
  return o;
};

export const modifyOrSetImpl = (key) => (f) => (val) => (rec) => {
  const o = { ...rec };
  const rk = rec[key];
  if (rk !== undefined) {
    o[key] = f(rec[key]);
  } else {
    o[key] = val;
  }
  return o;
};
