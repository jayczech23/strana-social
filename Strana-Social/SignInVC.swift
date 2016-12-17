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
import SwiftKeychainWrapper


class SignInVC: UIViewController {

    @IBOutlet weak var emailTxtField: FancyField!
    @IBOutlet weak var passwordTxtField: FancyField!
    
//-----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
       
    }

//-----------------------------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        
        // if there is a key in the keychain (signed in user), go to FeedVC.
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("JAY: ID found in keychain.")
            performSegue(withIdentifier: feedSegue, sender: nil)
        }
        
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
    
    // Sign-in or register with an email account.
    @IBAction func signInBtnTapped(_ sender: Any) {
        
        guard let email = emailTxtField.text, email.characters.count > 0 && isValidEmail(testStr: email) else {
            print("Please enter a valid email address.")
            return
        }
        
        guard let password = passwordTxtField.text, password.characters.count >= 6 else {
            print("Please enter a password at least 6 characters long")
            return
        }
        
        // new user
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                print("Successfully Registered to Firebase w/ Email.")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            } else {
                // existing user
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        print(error)
                        print("JAY: Unable to authenticate w/ Firebase using email.")
                    } else {
                        print("JAY: Successfully Signed in to Firebase w/ email!")
                        if let user = user {
                            self.completeSignIn(id: user.uid)
                        }
                    }
                })
            }
        })
    }
//-----------------------------------------------------------------

    // step 2: authenticate with Firebase. (w/ credential from Facebook)
    func firebaseAuthenticate(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("JAY: Unable to Authenticate with Firebase.")
            } else {
                print("JAY: Successfully authenticated with Firebase!")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        })
    }
//-----------------------------------------------------------------
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
//-----------------------------------------------------------------
    
    func completeSignIn(id: String) {
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("JAY: data saved to keychiain \(keychainResult)")
        performSegue(withIdentifier: feedSegue, sender: nil)
        
    }
//-----------------------------------------------------------------
    
}













