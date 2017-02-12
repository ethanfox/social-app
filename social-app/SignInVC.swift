//
//  ViewController.swift
//  social-app
//
//  Created by Ethan Fox on 1/29/17.
//  Copyright © 2017 Ethan Fox. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper


class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
            
            
        }
    }

   

    @IBAction func facebookBtnTapped(_ sender: Any) {
   
        //*-*-*-*-*Facebook
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                
                print("ETHAN: Unable to Authenticate with Facebook - \(error)")
                
            } else if result?.isCancelled == true {
                
                print("ETHAN: User Denied Access")
        
            } else {
                
                print("ETHAN: User Allowed Access")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
                
            }
        }
    
    }
    
    //*-*-*-*-*Firebase
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                
                print("Unable to Authenticate with Firebase - \(error)")
                
            } else {
                
                print("Successfully Authenticated with Firebase")
                
                if let user = user {
                    
                    self.completeSignIn(id: user.uid)
                    
                
                }
            }
        })
        
    }
    
    
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    
                    print("Email User Authenticated with Firebase - Prepare for Sign In ")
                     self.completeSignIn(id: (user?.uid)!)
                    
                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            
                            print("FAILED: Unable to Authenticate with Firebase Email")
                        } else {
                            
                            print("SUCCESS: User Authenticated with Firebase Email")
                             self.completeSignIn(id: (user?.uid)!)
                        }
                    })
                    
                }
            })
            
        }
    }
 
    
    func completeSignIn(id: String) {
        
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("DATA SAVED TO KEYCHAIN")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    

}

    


