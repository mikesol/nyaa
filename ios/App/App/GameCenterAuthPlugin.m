//
//  GameCenterAuthPlugin.m
//  App
//
//  Created by Mike Solomon on 9.11.2022.
//

#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

CAP_PLUGIN(GameCenterAuthPlugin, "GameCenterAuth",
    CAP_PLUGIN_METHOD(signIn, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(eagerAuth, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(signOut, CAPPluginReturnPromise);
)
