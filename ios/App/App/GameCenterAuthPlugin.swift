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
import FirebaseStorage

struct CustomAuthResponse: Decodable {
    let result: String
}

@objc(GameCenterAuthPlugin)
public class GameCenterAuthPlugin: CAPPlugin {
    @objc func signOut(_ call: CAPPluginCall) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            call.resolve()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            call.reject("Could not sign out")
        }
    }
    
    static func signInCont(_ call: CAPPluginCall) {
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
                            var hasGC = false
                            for lnk in Auth.auth().currentUser?.providerData ?? [] {
                                if (lnk.providerID == "gc.apple.com") { hasGC = true
                                    break
                                }
                            }
                            if (hasGC) {
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
                                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                        changeRequest?.displayName = GKLocalPlayer.local.displayName
                                        GKLocalPlayer.local.loadPhoto(for: GKPlayer.PhotoSize.small) {(img, err)  in
                                            if (err != nil) {
                                                // no photo, no problem
                                                print("Could not get photo \(String(describing: err))")
                                                changeRequest?.commitChanges { err in
                                                    call.resolve(res)
                                                }
                                                return
                                            }
                                            guard let img = img else {
                                                print("No img \(String(describing: err))")
                                                changeRequest?.commitChanges { err in
                                                    call.resolve(res)
                                                }
                                                return
                                            }
                                            let storage = Storage.storage()
                                            let storageRef = storage.reference()
                                            guard let uid = Auth.auth().currentUser?.uid else {
                                                print("no uid")
                                                changeRequest?.commitChanges { err in
                                                    call.resolve(res)
                                                }
                                                return
                                            }
                                            let profileRef = storageRef.child("nyaaProfileImages/\(uid)")
                                            if let data = img.pngData()  {
                                                let metadata = StorageMetadata()
                                                metadata.contentType = "image/png"
                                                profileRef.putData(data, metadata: metadata) { (metadata, error) in
                                                    if (error != nil) {
                                                        print("Upload failed \(String(describing: error))")
                                                        changeRequest?.commitChanges { err in
                                                            call.resolve(res)
                                                        }
                                                        return
                                                    }
                                                    if (metadata == nil) {
                                                        print("No metadata")
                                                        changeRequest?.commitChanges { err in
                                                            call.resolve(res)
                                                        }
                                                        return
                                                    }
                                                    profileRef.downloadURL { (url, error) in
                                                        guard let downloadURL = url else {
                                                            print("No download url")
                                                            changeRequest?.commitChanges { err in
                                                                call.resolve(res)
                                                            }
                                                            return
                                                        }
                                                        changeRequest?.photoURL = downloadURL
                                                        changeRequest?.commitChanges { err in
                                                            call.resolve(res)
                                                        }
                                                    }
                                                }
                                            } else {
                                                changeRequest?.commitChanges { err in
                                                    call.resolve(res)
                                                }
                                                return
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    case let .failure(error):
                        call.reject("\(error)")
                    }
                }
            }
        } else {
            call.reject("Phone too old")
        }
    }
    
    @objc func signIn(_ call: CAPPluginCall) {
        print("starting sign in")
        if (GKLocalPlayer.local.isAuthenticated) {
            GameCenterAuthPlugin.signInCont(call)
        } else {
            GKLocalPlayer.local.authenticateHandler = { viewController, error in
                if let viewController = viewController {
                    print("presenting view controller for game center sign in")
                    // Present the view controller so the player can sign in.
                    DispatchQueue.main.async {
                        self.bridge?.viewController?.present(viewController, animated: true, completion: nil)
                    }
                    return
                }
                if error != nil {
                    print("got an error for game center")
                    // Player could not be authenticated.
                    // Disable Game Center in the game.
                    call.reject("Game center threw an error. \(String(describing: error))")
                    return
                }
                print("continuing sign in")
                GameCenterAuthPlugin.signInCont(call)
            }
        }
    }
    @objc func eagerAuth(_ call: CAPPluginCall) {
        print("starting eager auth")
        if (GKLocalPlayer.local.isAuthenticated) {
            call.resolve()
        } else {
            GKLocalPlayer.local.authenticateHandler = { viewController, error in
                if let viewController = viewController {
                    print("presenting view controller for game center sign in")
                    // Present the view controller so the player can sign in.
                    DispatchQueue.main.async {
                        self.bridge?.viewController?.present(viewController, animated: true, completion: nil)
                    }
                    return
                }
                if error != nil {
                    print("got an error for game center \(String(describing: error))")
                    // Player could not be authenticated.
                    // resolve for now, cross fingers
                    // that this will be handled at the sign-in stage
                    call.resolve()
                    return
                }
                print("continuing sign in")
                call.resolve()
            }
        }
    }
}
