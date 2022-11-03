//
//  GameCenterAuthPlugin.swift
//  App
//
//  Created by Mike Solomon on 3.11.2022.
//

import Foundation
import Capacitor
import GameKit
import FirebaseAuth

@objc(GameCenterAuthPlugin)
public class GameCenterAuthPlugin: CAPPlugin {
    @objc func signIn(_ call: CAPPluginCall) {
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
                call.reject("Game center threw an error. Deal with it!")
                return
            }
            
            // Player was successfully authenticated.
            // Check if there are any player restrictions before starting the game.
            
            if GKLocalPlayer.local.isUnderage {
                // Hide explicit game content.
            }
            
            if GKLocalPlayer.local.isMultiplayerGamingRestricted {
                // Disable multiplayer game features.
            }
            
            if #available(iOS 14.0, *) {
                if GKLocalPlayer.local.isPersonalizedCommunicationRestricted {
                    // Disable in game communication UI.
                }
            } else {
                // Fallback on earlier versions
            }
            // Perform any other configurations as needed (for example, access point).
            GameCenterAuthProvider.getCredential() { (credential, error) in
                if error != nil {
                    call.reject("Game center credential no like, you do something wrong.")
                    return
                }
                if let reallyCredential = credential {
                    // The credential can be used to sign in, or re-auth, or link or unlink.
                    Auth.auth().signIn(with:reallyCredential) { (user, error) in
                        if error != nil {
                            call.reject("Firebase auth no like, you make again.")
                            return
                        }
                        // Player is signed in!
                        let myUser = Auth.auth().currentUser
                        let userResult = FirebaseAuthenticationHelper.createUserResult(myUser)
                        var result = JSObject()
                        result["user"] = userResult
                        call.resolve(result)
                    }
                } else {
                    call.reject("Me no find cred, bad bad!")
                }
                
                
            }
        }
        
        
    }
    @objc func signOut(_ call: CAPPluginCall) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            call.resolve();
        } catch _ as NSError {
            call.reject("Error signing out!")
        }
    }
}
