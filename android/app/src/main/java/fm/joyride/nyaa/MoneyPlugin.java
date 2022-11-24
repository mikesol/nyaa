package fm.joyride.nyaa;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.android.billingclient.api.BillingClient;
import com.android.billingclient.api.BillingClientStateListener;
import com.android.billingclient.api.BillingFlowParams;
import com.android.billingclient.api.BillingResult;
import com.android.billingclient.api.ProductDetails;
import com.android.billingclient.api.ProductDetailsResponseListener;
import com.android.billingclient.api.Purchase;
import com.android.billingclient.api.PurchaseHistoryRecord;
import com.android.billingclient.api.PurchaseHistoryResponseListener;
import com.android.billingclient.api.PurchasesUpdatedListener;
import com.android.billingclient.api.QueryProductDetailsParams;
import com.android.billingclient.api.QueryPurchaseHistoryParams;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.google.common.collect.ImmutableList;

import java.util.List;

@CapacitorPlugin(name = "Money")
public class MoneyPlugin extends Plugin {

    private String callbackId = null;
    private boolean isConnected = false;
    private PurchasesUpdatedListener purchasesUpdatedListener = new PurchasesUpdatedListener() {
        @Override
        public void onPurchasesUpdated(BillingResult billingResult, List<Purchase> purchases) {
            PluginCall savedCall = getBridge().getSavedCall(callbackId);
            if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.OK) {
                savedCall.resolve();
            } else {
                savedCall.reject("Could not complete transaction: "+billingResult.getDebugMessage());
            }
        }
    };

    private BillingClient billingClient = null;

    @PluginMethod()
    public void initializeBillingClient(PluginCall call) {
        billingClient = BillingClient.newBuilder(getContext())
                .setListener(purchasesUpdatedListener)
                .enablePendingPurchases()
                .build();
        billingClient.startConnection(new BillingClientStateListener() {
            @Override
            public void onBillingSetupFinished(BillingResult billingResult) {
                if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.OK) {
                    isConnected = true;
                    call.resolve();
                } else {
                    isConnected = false;
                    call.reject("Could not set up billing client");
                }
            }
            @Override
            public void onBillingServiceDisconnected() {
                isConnected = false;
            }
        });
    }

    private void refreshStatusImpl(PluginCall call) {
        callbackId = call.getCallbackId();
        QueryPurchaseHistoryParams queryProductDetailsParams =
                QueryPurchaseHistoryParams.newBuilder()
                        .setProductType(BillingClient.ProductType.INAPP)
                        .build();

        billingClient.queryPurchaseHistoryAsync(queryProductDetailsParams, new PurchaseHistoryResponseListener() {
            @Override
            public void onPurchaseHistoryResponse(@NonNull BillingResult billingResult, @Nullable List<PurchaseHistoryRecord> list) {
                if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.OK
                        && list != null && list.size() != 0) {
                    call.resolve();
                    return;
                }
                call.reject("Could not find purchase");
            }
        });
    }

    private void buyImpl(PluginCall call) {
        callbackId = call.getCallbackId();

        QueryProductDetailsParams queryProductDetailsParams =
                QueryProductDetailsParams.newBuilder()
                        .setProductList(
                                ImmutableList.of(
                                        QueryProductDetailsParams.Product.newBuilder()
                                                .setProductId("nyaa.track.ac.0")
                                                .setProductType(BillingClient.ProductType.INAPP)
                                                .build()))
                        .build();

        billingClient.queryProductDetailsAsync(
                queryProductDetailsParams,
                new ProductDetailsResponseListener() {
                    public void onProductDetailsResponse(BillingResult billingResult,
                                                         List<ProductDetails> productDetailsList) {
                        for (int i = 0; i < productDetailsList.size(); i++) {
                            if (productDetailsList.get(i).getProductId() == "nyaa.track.ac.0") {
                                ImmutableList productDetailsParamsList =
                                        ImmutableList.of(
                                                BillingFlowParams.ProductDetailsParams.newBuilder()
                                                        .setProductDetails(productDetailsList.get(i))
                                                        .build()
                                        );

                                BillingFlowParams billingFlowParams = BillingFlowParams.newBuilder()
                                        .setProductDetailsParamsList(productDetailsParamsList)
                                        .build();

                                // Launch the billing flow
                                BillingResult billingResultFromLaunch = billingClient.launchBillingFlow(getActivity(), billingFlowParams);
                                if (billingResultFromLaunch.getResponseCode() == BillingClient.BillingResponseCode.OK) {
                                    getBridge().saveCall(call);
                                } else {
                                    call.reject("Could not ");
                                }
                                return;
                            }
                        }
                        call.reject("Could not find product");
                    }
                }
        );

    }

    @PluginMethod()
    public void refreshStatus(PluginCall call) {
        if (!isConnected) {
            billingClient.startConnection(new BillingClientStateListener() {
                @Override
                public void onBillingSetupFinished(BillingResult billingResult) {
                    if (billingResult.getResponseCode() ==  BillingClient.BillingResponseCode.OK) {
                        isConnected = true;
                        refreshStatusImpl(call);
                    } else {
                        isConnected = false;
                        call.reject("Could not set up billing client");
                    }
                }
                @Override
                public void onBillingServiceDisconnected() {
                    isConnected = false;
                    call.reject("Is disconnected");
                }
            });
        }
    }

    @PluginMethod()
    public void buy(PluginCall call) {
        if (!isConnected) {
            billingClient.startConnection(new BillingClientStateListener() {
                @Override
                public void onBillingSetupFinished(BillingResult billingResult) {
                    if (billingResult.getResponseCode() ==  BillingClient.BillingResponseCode.OK) {
                        isConnected = true;
                        buyImpl(call);
                    } else {
                        isConnected = false;
                        call.reject("Could not set up billing client");
                    }
                }
                @Override
                public void onBillingServiceDisconnected() {
                    isConnected = false;
                    call.reject("Is disconnected");
                }
            });
        }
    }
}