export const getImpl = (just) => (nothing) => (key) => (rec) =>
  rec[key] === undefined ? nothing : just(rec[key]);

export const setImpl = (key) => (val) => (rec) => {
  const o = { ...rec };
  o[key] = val;
  return o;
};
