export const customComponentImpl =
    (componentName) => (localProps) => (connectedHook) => (disconnectedHook) => (run) => () => {
    class CustomComponent extends HTMLElement {
      constructor() {
        super();
        this.ionic$locals = undefined;
        this.deku$unsubscribe = undefined;
      }
      disconnectedCallback() {
        this.deku$unsubscribe && this.deku$unsubscribe();
        this.deku$unsubscribe = undefined;
        disconnectedHook(this.ionic$locals)();
      }
      connectedCallback() {
        this.ionic$locals = {};
        for (var i = 0; i < localProps.length; i++) {
          this.ionic$locals[localProps[i]] = this[localProps[i]];
        }
        this.deku$unsubscribe = run(this)(this.ionic$locals)();
        connectedHook(this.ionic$locals)();
      }
    }

    window.customElements.define(componentName, CustomComponent);
  };
