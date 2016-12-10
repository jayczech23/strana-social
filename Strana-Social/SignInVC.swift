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

    @IBOutlet weak var emailTxtField: FancyField!
    @IBOutlet weak var passwordTxtField: FancyField!
    
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
    @IBAction func signInBtnTapped(_ sender: Any) {
        
        guard let email = emailTxtField.text, email.characters.count > 0 && isValidEmail(testStr: email) else {
            print("Please enter a valid email address.")
            return
        }
        
        guard let password = passwordTxtField.text, password.characters.count >= 6 else {
            print("Please enter a password at least 6 characters long")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                print("Successfully Signed In w/ Email.")
            } else {
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        print("JAY: Unable to authenticate w/ Firebase using email.")
                    } else {
                        print("JAY: Successfully REGISTERED w/ email!")
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
}













