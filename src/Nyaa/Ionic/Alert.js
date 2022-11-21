export const alertImpl =
  (header) => (subHeader) => (message) => (buttons) => async () => {
    const alert = document.createElement("ion-alert");
    alert.header = header;
    if (subHeader) {
      alert.subHeader = subHeader;
    }
    if (message) {
      alert.message = message;
    }
    alert.buttons = buttons;

    document.body.appendChild(alert);
    await alert.present();
  };
