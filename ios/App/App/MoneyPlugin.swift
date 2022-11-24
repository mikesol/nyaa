//
//  MoneyPlugin.swift
//  App
//
//  Created by Mike Solomon on 24.11.2022.
//

import Capacitor
import StoreKit

@objc(MoneyPlugin)
public class MoneyPlugin: CAPPlugin {
    @objc func initialize(_ call: CAPPluginCall) {
        call.resolve();
    }
    @objc func refreshStatus(_ call: CAPPluginCall) {
        Task {
            if #available(iOS 15.0, *) {
                do {
                    let products = try await Product.products(for: ["nyaa.track.ac.0"])
                    for product in products {
                        if product.id == "nyaa.track.ac.0" {
                            guard let resultingTransaction = await product.latestTransaction else {
                                call.reject("No latest transaction")
                                return
                            }
                            guard case .verified(_) = resultingTransaction else {
                                call.reject("Transaction not verified")
                                return
                            }
                            call.resolve()
                            return;
                        }
                    }
                    call.reject("Could not find product");
                } catch {
                    call.reject("Could not access store kit \(error)")
                }
            } else {
                call.reject("App too old")
            };
        }
    }
    @objc func buy(_ call: CAPPluginCall) {
        Task {
            if #available(iOS 15.0, *) {
                do {
                    let products = try await Product.products(for: ["nyaa.track.ac.0"])
                    print("Products size \(products.count)")
                    for product in products {
                        if product.id == "nyaa.track.ac.0" {
                            let result = try await product.purchase();
                            switch result {
                            case .pending:
                                call.reject("Transaction pending")
                                return
                            case .userCancelled:
                                call.reject("Transaction canceled")
                                return
                            case .success(let verificationResult):
                                switch verificationResult {
                                case .verified(let transaction):
                                    await transaction.finish()
                                    call.resolve()
                                    return
                                case .unverified(let transaction, let verificationError):
                                    call.reject("Unverified transaction \(transaction) \(verificationError)")
                                    return
                                }
                            @unknown default:
                                call.reject("Unknown branch in pattern match")
                            }
                            return;
                        }
                    }
                    call.reject("Could not find product");
                } catch {
                    call.reject("Could not access store kit \(error)")
                }
            } else {
                call.reject("App too old")
            };
        }
    }
}
