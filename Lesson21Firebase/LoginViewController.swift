//
//  LoginViewController.swift
//  Lesson21Firebase
//
//  Created by Алина Власенко on 21.04.2023.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet private weak var loginButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self)
    }
    
    //Не вдалі намагання підключити автентифікацію.
        
//        let userAuthentication = GIDSignIn.sharedInstance.signIn(withPresenting: self)
//
//        let user = userAuthentication.user
//
//        guard let idToken = user.idToken else {
//            print("ID token missing")
              //AuthenticationError.tokenError(message: "ID token missing") - не працює код, запропонований на Firebase
//        }
//            let accessToken = user.accessToken
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
//                                                                           accessToken: accessToken.tokenString)
//            let result = try await Auth.auth().signIn(with: credential)
//            let firebaseUser = result.user
//            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "Unknown")")
//    }
//

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
