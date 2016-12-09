//
//  ViewController.swift
//  Strana-Social
//
//  Created by Jordan Cech on 12/6/16.
//  Copyright © 2016 Strana LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookCore
import FacebookLogin



class SignInVC: UIViewController {

 
    
//-----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

//----------------------------------------------------------------

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let loginManager = LoginManager()
        loginManager.logIn([ ReadPermission.publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login to Facebook.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in to Facebook!")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                self.firebaseAuthenticate(credential)
            }
        }
    }
 
//-----------------------------------------------------------------

    // step 2: authenticate with Firebase.
    func firebaseAuthenticate(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("JAY: Unable to Authenticate with Firebase.")
            
            } else {
                print("JAY: Successfully authenticated with Firebase!")
            }
        })
    }
//-----------------------------------------------------------------
}













