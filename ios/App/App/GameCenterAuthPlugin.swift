//
//  GameCenterAuthPlugin.swift
//  App
//
//  Created by Mike Solomon on 3.11.2022.
//
import Foundation
import Capacitor
import GameKit
import Alamofire
import FirebaseAuth

struct CustomAuthResponse: Decodable {
    let result: String
}

@objc(GameCenterAuthPlugin)
public class GameCenterAuthPlugin: CAPPlugin {
    @objc func signIn(_ call: CAPPluginCall) {
        print("starting")
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // Present the view controller so the player can sign in.
                DispatchQueue.main.async {
                    self.bridge?.viewController?.present(viewController, animated: true, completion: nil)
                }
                return
            }
            if error != nil {
                // Player could not be authenticated.
                // Disable Game Center in the game.
                call.reject("Game center threw an error. \(String(describing: error))")
                return
            }
            if #available(iOS 13.5, *) {
                GKLocalPlayer.local.fetchItems { publicKeyURL, signature, salt, timestamp, error in
                    var pkurl = ""
                    if let publicKeyURL = publicKeyURL {
                        pkurl = "\(publicKeyURL)"
                    }
                    let parameters: [String: String?] = [
                        "publicKeyURL": pkurl,
                        "signature": signature?.base64EncodedString(),
                        "salt": salt?.base64EncodedString(),
                        "timestamp": "\(timestamp)",
                        "gamePlayerID": GKLocalPlayer.local.gamePlayerID,
                        "teamPlayerID": GKLocalPlayer.local.teamPlayerID,
                        "displayName":GKLocalPlayer.local.displayName,
                        "alias": GKLocalPlayer.local.alias
                    ]
                    AF.request("https://us-central1-nyaa-game.cloudfunctions.net/gcAuth", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseDecodable(of: CustomAuthResponse.self) { response in
                        switch response.result {
                        case .success:
                            
                            Auth.auth().signIn(withCustomToken: response.value?.result ?? "") { (result, err) in
                                if (err != nil) {
                                    call.reject("\(String(describing: err))")
                                    return
                                }
                                if ((Auth.auth().currentUser?.providerData.count ?? 0) > 1) {
                                    // we're already linked to something else, so we can return early
                                    var res = JSObject()
                                    res["result"] = response.value?.result;
                                    res["gamePlayerID"] = GKLocalPlayer.local.gamePlayerID;
                                    res["teamPlayerID"] = GKLocalPlayer.local.teamPlayerID;
                                    res["displayName"] = GKLocalPlayer.local.displayName;
                                    res["alias"] = GKLocalPlayer.local.alias;
                                    res["refreshToken"] = Auth.auth().currentUser?.refreshToken
                                    call.resolve(res)
                                    return
                                }
                                GameCenterAuthProvider.getCredential() { (credential, err) in
                                    if (err != nil ){
                                        call.reject("\(String(describing: error))")
                                        return
                                    }
                                    if let credential = credential {
                                        Auth.auth().currentUser?.link(with: credential) { (res, err) in
                                            if (err != nil) {
                                                call.reject("\(String(describing: err))")
                                                return
                                            }
                                            var res = JSObject()
                                            res["result"] = response.value?.result;
                                            res["gamePlayerID"] = GKLocalPlayer.local.gamePlayerID;
                                            res["teamPlayerID"] = GKLocalPlayer.local.teamPlayerID;
                                            res["displayName"] = GKLocalPlayer.local.displayName;
                                            res["alias"] = GKLocalPlayer.local.alias;
                                            call.resolve(res)
                                        }
                                    }
                                }}
                        case let .failure(error):
                            call.reject("\(error)")
                        }
                    }
                }
            } else {
                call.reject("Phone too old")
            }
        }
    }
}
