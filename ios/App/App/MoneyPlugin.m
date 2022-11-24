//
//  MoneyPlugin.m
//  App
//
//  Created by Mike Solomon on 24.11.2022.
//

#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

CAP_PLUGIN(MoneyPlugin, "Money",
    CAP_PLUGIN_METHOD(buy, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(refreshStatus, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(initialize, CAPPluginReturnPromise);
)
