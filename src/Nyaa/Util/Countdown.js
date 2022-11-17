export const countdown = (ms) => (i) => (execute) => (done) => () => {
  if (i < 0) {
    return () => {};
  }
  const j = { i };
  let unsub;
  unsub = setInterval(() => {
    if (j.i < 0) {
      clearInterval(unsub);
      done();
      return;
    }
    execute(j.i)();
    j.i -= 1;
  }, ms);
  return () => {
    clearInterval(unsub);
  };
};
