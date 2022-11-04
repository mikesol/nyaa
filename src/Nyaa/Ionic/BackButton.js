export const routerAnimation = (item) => (routerAnimation) => () => {
  item.routerAnimation = routerAnimation;
};
export const getRouterAnimation = (item) => () => item.routerAnimation;
