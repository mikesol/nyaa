//
//  FriendsPlugin.m
//  App
//
//  Created by Mike Solomon on 9.11.2022.
//

#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

CAP_PLUGIN(FriendsPlugin, "Friends",
    CAP_PLUGIN_METHOD(sendFriendRequest, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(getFriends, CAPPluginReturnPromise);
)
