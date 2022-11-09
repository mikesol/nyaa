//
//  FriendsPlugin.swift
//  App
//
//  Created by Mike Solomon on 9.11.2022.
//

import Foundation
import Capacitor
import GameKit

@objc(FriendsPlugin)
public class FriendsPlugin: CAPPlugin {
    @objc func sendFriendRequest(_ call: CAPPluginCall) {
        if let viewController = self.bridge?.viewController {
            do {
                if #available(iOS 15.0, *) {
                    try GKLocalPlayer.local.presentFriendRequestCreator(from: viewController)
                    call.resolve()
                } else {
                    call.reject("Cannot access friend list before iOS 15.0", "IOS_VERSION_TOO_OLD")
                }
            } catch {
                call.reject("\(error.localizedDescription).", "CANNOT_PRESENT_FRIEND_LIST")
            }
        } else {
            call.reject("View Controller not defined", "VIEW_CONTROLLER_NOT_DEFINED")
        }
    }

    @objc func getFriends(_ call: CAPPluginCall) {
        Task {
            do {
                if #available(iOS 14.5, *) {
                    let authorizationStatus = try await GKLocalPlayer.local.loadFriendsAuthorizationStatus()
                    // Handle GKFriendsAuthorizationStatus.
                    switch authorizationStatus {
                    case .notDetermined:
                        // The player hasn't denied or authorized access to their friends.
                        await FriendsPlugin.marshallFriends(call)
                    case .denied:
                        call.reject("Access to friends is denied.", "ACCESS_TO_FRIENDS_DENIED");
                    case .restricted:
                        call.reject("Access to friends is restricted.", "ACCESS_TO_FRIENDS_RESTRICTED");
                    case .authorized:
                        // The player authorizes your request to access their friends.
                        await FriendsPlugin.marshallFriends(call)
                    @unknown default:
                        call.reject("Access to friends is unknown.", "ACCESS_TO_FRIENDS_UNKNOWN");
                    }
                } else {
                    call.reject("Cannot get friends before iOS 14.5", "IOS_VERSION_TOO_OLD")
                }
                
                
            } catch {
                print("Error: \(error.localizedDescription).")
            }
        }
    }

    public static func marshallFriends(_ call: CAPPluginCall) async {
        do {
            if #available(iOS 14.5, *) {
                let friends = try await GKLocalPlayer.local.loadFriends()
                var jsFriendlyFreinds = [JSObject]()
                for friend in friends {
                    let jsFriend = await FriendsPlugin.createFriendResult(friend)
                    jsFriendlyFreinds.append(jsFriend)
                }
                var result = JSObject()
                result["friends"] = jsFriendlyFreinds
                call.resolve(result)
            } else {
                call.reject("Cannot get friends before iOS 14.5", "IOS_VERSION_TOO_OLD")
            }
        } catch {
            call.reject("Cannot load friends", "CANNOT_LOAD_FRIENDS")
        }
    }

    public static func createFriendResult(_ friend: GKPlayer) async -> JSObject {
        var result = JSObject()
        result["displayName"] = friend.displayName
        result["alias"] = friend.alias
        result["gamePlayerID"] = friend.gamePlayerID
        result["teamPlayerID"] = friend.teamPlayerID
        do {
            let photo = try await friend.loadPhoto(for: GKPlayer.PhotoSize.small)
            let asJpeg = photo.jpegData(compressionQuality: 0.5)
            let asData = asJpeg?.base64EncodedString()
            if let realData = asData {
                result["avatar"] = realData;
            } else {
                result["avatar"] = nil;
            }
        } catch {
            result["avatar"] = nil;
        }
        return result
    }
}
