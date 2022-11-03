export const back = (router) => () => router.back();
export const push = (router) => (path) => (direction) => (animation) => () =>
  router.push(path, direction, animation);
