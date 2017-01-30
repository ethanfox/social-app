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


class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            }
        })
        
    }
    
    
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    
                    print("Email User Authenticated with Firebase - Prepare for Sign In ")
                    
                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            
                            print("FAILED: Unable to Authenticate with Firebase Email")
                        } else {
                            
                            print("SUCCESS: User Authenticated with Firebase Email")
                        }
                    })
                    
                }
            })
            
        }
    }
    

}

