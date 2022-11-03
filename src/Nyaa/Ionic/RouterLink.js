export const routerAnimation = (router) => (animation) => () => { router.routerAnimation = animation; }
export const getRouterAnimation = (router) =>  () => router.routerAnimation ;