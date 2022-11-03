// getScrollElement​
// Description	Get the element where the actual scrolling takes place. This element can be used to subscribe to scroll events or manually modify scrollTop. However, it's recommended to use the API provided by ion-content:

// i.e. Using ionScroll, ionScrollStart, ionScrollEnd for scrolling events and scrollToPoint() to scroll the content into a certain point.
// Signature	getScrollElement() => Promise<HTMLElement>
export const getScrollElement = (content) => () => content.getScrollElement();
// scrollByPoint​
// Description	Scroll by a specified X/Y distance in the component.
// Signature	scrollByPoint(x: number, y: number, duration: number) => Promise<void>
export const scrollByPoint = (content) => (x) => (y) => (duration) => () => content.scrollByPoint(x,y,duration);
// scrollToBottom​
// Description	Scroll to the bottom of the component.
// Signature	scrollToBottom(duration?: number) => Promise<void>
export const scrollToBottom = (content) =>  (duration) => () => content.scrollByPoint(duration);
// scrollToPoint​
// Description	Scroll to a specified X/Y location in the component.
// Signature	scrollToPoint(x: number ｜ undefined ｜ null, y: number ｜ undefined ｜ null, duration?: number) => Promise<void>
export const scrollToPoint = (content) => (x) => (y) => (duration) => () => content.scrollToPoint(x,y,duration);
// scrollToTop​
// Description	Scroll to the top of the component.
// Signature	scrollToTop(duration?: number) => Promise<void>
export const scrollToTop = (content) =>  (duration) => () => content.scrollByPoint(duration);
