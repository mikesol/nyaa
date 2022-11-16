export const breakpoints = (modal) => (b) => () => {modal.breakpoints = b;}
export const getBreakpoints = (modal) => () => modal.breakpoints;
export const enterAnimation = (modal) => (b) => () => {modal.enterAnimation = b;}
export const getEnterAnimation = (modal) => () => modal.enterAnimation;
export const htmlAttributes = (modal) => (b) => () => {modal.htmlAttributes = b;}
export const getHtmlAttributes = (modal) => () => modal.htmlAttributes;
export const leaveAnimation = (modal) => (b) => () => {modal.leaveAnimation = b;}
export const getLeaveAnimation = (modal) => () => modal.leaveAnimation;
export const presentingElement = (modal) => (b) => () => {modal.presentingElement = b;}
export const getPresentingElement = (modal) => () => modal.presentingElement;
export const dismiss = (modal) => (data) => (role) => () => modal.dismiss(data, role)
export const getCurrentBreakpoint = (modal) => () => modal.getCurrentBreakpoint()
export const onDidDismiss = (modal) => () => modal.onDidDismiss()
export const onWillDismiss = (modal) => () => modal.onDidDismiss()
export const present = (modal) => () => modal.present()
export const setCurrentBreakpoint = (modal) => (breakpoint) => () => modal.setCurrentBreakpoint(breakpoint);