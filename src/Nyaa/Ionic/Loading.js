import { loadingController } from "@ionic/core";

export const presentLoading = (message) => async () => {
  const loading = await loadingController.create({
    message,
  });

  loading.present();
  return loading;
};

export const dismissLoading = (loading) => async () => {
  await loading.dismiss();
};
