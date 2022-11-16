//
//  GameCenterPlugin.m
//  App
//
//  Created by Mike Solomon on 15.11.2022.
//

#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

CAP_PLUGIN(GameCenterPlugin, "GameCenter",
    CAP_PLUGIN_METHOD(showAccessPoint, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(hideAccessPoint, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(showGameCenter, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(getLeaderboard, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(submitScore, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(getAchievements, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(reportAchievements, CAPPluginReturnPromise);
)
