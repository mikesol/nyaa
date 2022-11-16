export const customComponentImpl =
  (componentName) => (localProps) => (connectedHook) => (disconnectedHook) => (run) => () => {
    class CustomComponent extends HTMLElement {
      constructor() {
        super();
        this.deku$unsubscribe = undefined;
      }
      disconnectedCallback() {
        this.deku$unsubscribe && this.deku$unsubscribe();
          this.deku$unsubscribe = undefined;
          disconnectedHook();
      }
      connectedCallback() {
        const locals = {};
        for (var i = 0; i < localProps.length; i++) {
          locals[localProps[i]] = this[localProps[i]];
        }
        this.deku$unsubscribe = run(this)(locals)();
        connectedHook(locals);
      }
    }

    window.customElements.define(componentName, CustomComponent);
  };
