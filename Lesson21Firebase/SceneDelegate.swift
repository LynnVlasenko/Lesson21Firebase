//
//  SceneDelegate.swift
//  Lesson21Firebase
//
//  Created by Алина Власенко on 04.04.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, 
               willConnectTo session: UISceneSession, 
               options connectionOptions: UIScene.ConnectionOptions) {
        
        func signInWithGoogle() async -> Bool {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                fatalError("No client ID found in Firebase configuration")
            }
            let config = GIDConfiguration (clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  window.rootViewController == LoginViewController(),
                  let rootViewController = window.rootViewController else {
                print("There is no root view controller")
                return false
            }
            do {
                let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                let user = userAuthentication.user
                guard let idToken = user.idToken else {
                    fatalError("ID token missing")
                    //AuthenticationError.tokenError(message: "ID token missing") - не працює код, запропонований на Firebase
                }
                let accessToken = user.accessToken
                let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                               accessToken: accessToken.tokenString)
                let result = try await Auth.auth().signIn(with: credential)
                let firebaseUser = result.user
                print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "Unknown")")
                return true
            }
            catch {
                print(error.localizedDescription)
                //errorMessage = error.localizedDescription //nvf
                return false
            }
            // replace this with the implementation
            // return false
        }
    }
}
        //       Намагання підключити GoogleSignIn
        
        //        guard let _ = (scene as? UIWindowScene) else { return }
        //
        //        guard let clientID = FirebaseApp.app()?.options.clientID else {
        //            fatalError("No client ID found in Firebase configuration")
        //        }
        //
        //        // Create Google Sign In configuration object.
        //        let config = GIDConfiguration(clientID: clientID)
        //        GIDSignIn.sharedInstance.configuration = config
        //
        
        //        налаштування для GoogleSingIn
        //        задаємо clientID, який беремо з GoogleService-Info.plist. 
        //        Це можна зробити інакше - зчитуючи інформацію з plist-а по ключу CLIENT_ID. 
        //        Але команди не працюють і навіть укстеншн не можу зробити, нема просто навіть GIDSignInDelegate
        
        //        GIDSignIn.sharedInstance().clientID = "945713122832-hsa7tv1jgm4qbvra27hb6ad5s7ttlcfq.apps.googleusercontent.com"
        //        GIDSignIn.sharedInstance().delegate = self
        //    }
        //
        //}
        //
        //extension SceneDelegate: GIDSignInDelegate {
        //
        //    func sign(_ signin: GibSignin!, didSigninFor user: gIDGoogleUser!, watherror error: Error!) {
        //        print (user.profile.name as Any, user.profile.email as Any, "signed in!!!!!!!!")
        //    }
