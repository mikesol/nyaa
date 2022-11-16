export const alertImpl =
  (header) => (subHeader) => (message) => (buttonTxt) => async () => {
    const alert = document.createElement("ion-alert");
    alert.header = header;
    if (subHeader) {
      alert.subHeader = subHeader;
    }
    if (message) {
      alert.message = message;
    }
    alert.buttons = [buttonTxt];

    document.body.appendChild(alert);
    await alert.present();
  };
