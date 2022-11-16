//
//  GameCenterPlugin.swift
//  App
//
//  Created by Mike Solomon on 15.11.2022.
//

import Foundation
import Capacitor
import GameKit
import Alamofire
import FirebaseAuth
import FirebaseStorage

struct JSAchievement {
    let id: String
    let percentComplete: Double
}

@objc(GameCenterPlugin)
public class GameCenterPlugin: CAPPlugin {
    var gcCallID: String?
    static let DEFAULT_LEADERBOARD_CONTEXT = 0
    @objc func showAccessPoint(_ call: CAPPluginCall) {
        if #available(iOS 14.0, *) {
            let location = call.getString("location", "topLeading")
            GKAccessPoint.shared.location =
            location == "topLeading"
            ? .topLeading
            : location == "bottomLeading"
            ? .bottomLeading
            : location == "topTrailing"
            ? .topTrailing
            : location == "bottomTrailing"
            ? .bottomTrailing
            : .topLeading
            let showHighlights = call.getBool("showHighlights", true)
            GKAccessPoint.shared.showHighlights = showHighlights
            GKAccessPoint.shared.isActive = true
            call.resolve()
        } else {
            call.reject("Too old")
        }
        
    }
    @objc func hideAccessPoint(_ call: CAPPluginCall) {
        if #available(iOS 14.0, *) {
            GKAccessPoint.shared.isActive = false
            call.resolve()
        } else {
            call.reject("Too old")
        }
    }
    @objc func showGameCenter(_ call: CAPPluginCall) {
        if #available(iOS 14.0, *) {
            bridge?.saveCall(call)
            gcCallID = call.callbackId
            let state = call.getString("state", "dashboard")
            DispatchQueue.main.async {
                let viewController = GKGameCenterViewController(state: state == "achievements"
                                                                ? .achievements
                                                                : state == "challenges"
                                                                ? .challenges
                                                                : state == "dashboard"
                                                                ? .dashboard
                                                                : state == "leaderboards"
                                                                ? .leaderboards
                                                                : state == "localPlayerFriendsList"
                                                                ? .localPlayerFriendsList
                                                                : state == "localPlayerProfile"
                                                                ? .localPlayerProfile
                                                                : .dashboard)
                viewController.gameCenterDelegate = self
                
                self.bridge?.viewController?.present(viewController, animated: true, completion: nil)}
        } else {
            call.reject("Too old")
        }
    }
    @available(iOS 14.0, *)
    private static func loadEntry(_ entry: GKLeaderboard.Entry) async -> JSObject {
        var remotePlayer = JSObject()
        remotePlayer["rank"] = entry.rank
        remotePlayer["score"] = entry.score
        remotePlayer["formattedScore"] = entry.formattedScore
        remotePlayer["date"] = entry.date
        remotePlayer["displayName"] = entry.player.displayName
        remotePlayer["alias"] = entry.player.alias
        remotePlayer["gamePlayerID"] = entry.player.gamePlayerID
        remotePlayer["teamPlayerID"] = entry.player.teamPlayerID
        let avatar = await withCheckedContinuation { (continuation: CheckedContinuation<String?, Never>) in
            entry.player.loadPhoto(for: .small) { (photo, error) in
                if (error != nil) {
                    continuation.resume(returning: nil)
                    return;
                } else {
                    continuation.resume(returning: photo?.pngData()?.base64EncodedString())
                }
            }
        }
        remotePlayer["avatar"] = avatar
        return remotePlayer
    }
    @objc func submitScore(_ call: CAPPluginCall) {
        guard let leaderboardID = call.getString("leaderboardID") else { call.reject("No id"); return; }
        guard let points = call.getInt("points") else { call.reject("No points"); return; }
        if #available(iOS 14.0, *) {
            GKLeaderboard.submitScore(points, context: GameCenterPlugin.DEFAULT_LEADERBOARD_CONTEXT, player: GKLocalPlayer.local, leaderboardIDs: [leaderboardID]) { error in
                if (error != nil) { call.reject("\(String(describing: error))"); return; }
                call.resolve();
            }
        } else {
            call.reject("Too old")
        }
    }
    @objc func reportAchievements(_ call: CAPPluginCall) {
        guard let jsAchievements = call.getArray("achievements")?.capacitor.replacingNullValues() as? [JSObject?] else { call.reject("No achievements"); return; }
        var _achievements: [JSAchievement] = []
        for jsAchievement in jsAchievements {
            if let jsAchievement = jsAchievement {
                guard let achievementID = jsAchievement["achievementID"] as? String else { call.reject("No id"); return; }
                guard let percentComplete = jsAchievement["percentComplete"] as? Double else { call.reject("No percent complete");
                    return;
                }
                _achievements.append(JSAchievement(id: achievementID, percentComplete: percentComplete))
            }
        }
        // now do the updating
        GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
            if error != nil {
                call.reject("Error: \(String(describing: error))")
                return;
            }
            var achievementsToReport: [GKAchievement] = []
            for _achievement in _achievements {
                let achievementID = _achievement.id
                var achievement: GKAchievement? = nil
                
                // Find an existing achievement.
                achievement = achievements?.first(where: { $0.identifier == achievementID})
                
                // Otherwise, create a new achievement.
                if achievement == nil {
                    achievement = GKAchievement(identifier: achievementID)
                }
                achievement?.percentComplete = _achievement.percentComplete
                if let achievement = achievement { achievementsToReport.append(achievement) }
            }
            GKAchievement.report(achievementsToReport, withCompletionHandler: {(error: Error?) in
                if error != nil {
                    // Handle the error that occurs.
                    call.reject("Error: \(String(describing: error))")
                    return
                }
                call.resolve()
            })
            
        })
    }
    @objc func getAchievements(_ call: CAPPluginCall) {
        GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
            if error != nil {
                call.reject("Error: \(String(describing: error))")
                return;
            }
            var jsAchievements = []
            for achievement in (achievements ?? []) {
                var jsAchievement = JSObject()
                jsAchievement["identifier"] = achievement.identifier
                jsAchievement["isCompleted"] = achievement.isCompleted
                jsAchievement["lastReportedDate"] = achievement.lastReportedDate
                jsAchievement["percentComplete"] = achievement.percentComplete
                jsAchievement["showsCompletionBanner"] = achievement.showsCompletionBanner
                jsAchievements.append(jsAchievement)
            }
            var res = JSObject()
            res["achievements"] = jsAchievements
            call.resolve(res)
        })
    }
    @objc func getLeaderboard(_ call: CAPPluginCall) {
        guard let leaderboardID = call.getString("leaderboardID") else { call.reject("No id"); return; }
        if #available(iOS 14.0, *) {
            GKLeaderboard.loadLeaderboards(IDs: [leaderboardID]) {(fetchedLBs, error) in
                guard let lb = fetchedLBs?.first else { call.reject("Could not find leaderboard"); return }
                lb.loadEntries(for: .global, timeScope: .allTime, range: NSMakeRange(1, 30)) {(localPlayerEntry, entries, totalPlayerCount, error) in
                    if (error != nil) {
                        call.reject("Could not fetch from leaderboard: \(String(describing: error))")
                        return;
                    }
                    Task.init {
                        var jsEntries = []
                        if let entries = entries {
                            await withTaskGroup(of: (JSObject).self) { group in
                                for entry in entries {
                                    group.addTask { await GameCenterPlugin.loadEntry(entry) }
                                }
                                while let object = await group.next() {
                                    jsEntries.append(object)
                                }
                            }
                        }
                        var localPlayer = JSObject()
                        localPlayer["rank"] = localPlayerEntry?.rank
                        localPlayer["score"] = localPlayerEntry?.score
                        localPlayer["formattedScore"] = localPlayerEntry?.formattedScore
                        localPlayer["date"] = localPlayerEntry?.date
                        var res = JSObject()
                        res["localPlayer"] = localPlayer
                        res["entries"] = jsEntries
                        call.resolve(res)
                    }
                }
            }
        }
        else {
            call.reject("Too old")
        }
    }
}
extension GameCenterPlugin: GKGameCenterControllerDelegate {
    public func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        print("getting back")
        if let callID = gcCallID, let call = bridge?.savedCall(withID: callID) {
            print("found saved call")
            call.resolve()
            bridge?.releaseCall(call)
            gameCenterViewController.dismiss(animated:true)
        }
    }
}

