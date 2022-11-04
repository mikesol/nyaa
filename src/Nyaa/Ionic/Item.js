export const counterFormatter = (item) => (counterFormatter) => () => {
  item.counterFormatter = counterFormatter;
};
export const getCounterFormatter = (item) => () => item.counterFormatter;

export const routerAnimation = (item) => (routerAnimation) => () => {
  item.routerAnimation = routerAnimation;
};
export const getRouterAnimation = (item) => () => item.routerAnimation;
