export const beforeEnter = (router) => (cb) => () => {
  router.beforeEnter = cb;
};
export const beforeLeave = (router) => (cb) => () => {
  router.beforeLeave = cb;
};
export const componentProps = (router) => (props) => () => {
  router.componentProps = props;
};
export const getBeforeEnter = (router) => () => router.beforeEnter;
export const getBeforeLeave = (router) => () => router.beforeLeave;
export const getComponentProps = (router) => () => router.componentProps;
