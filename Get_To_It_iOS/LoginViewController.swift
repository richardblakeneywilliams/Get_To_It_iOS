//
//  LoginViewController.swift
//  Get_To_It_iOS
//
//  Created by Richard Blakeney-Williams on 21/04/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController,FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    func showMainTabScreen(){
        // Get main screen from storyboard and present it
        print("showTabScreen")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: MainTabViewController = (storyboard.instantiateViewControllerWithIdentifier("mainTabbedScreen") as! MainTabViewController)
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    //Email Login
    @IBAction func loginAction(sender: AnyObject) {
        if let email = self.emailTextField.text, let password = self.passwordTextField.text {
            FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    NSUserDefaults.standardUserDefaults().setObject(user!.uid, forKey: "uid")
                    print("Logged In")
                    self.showMainTabScreen()
                }
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter Email and Password.", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //Facebook Login Shit
   func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
        if let error = error {
            print(error.localizedDescription)
            return
        } else {
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            NSUserDefaults.standardUserDefaults().setObject(user!.uid, forKey: "uid")
            self.showMainTabScreen()
            }
        }
    }
    
    //Logout Facebook
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton) {
        try! FIRAuth.auth()!.signOut()
    }
    
    @IBAction func forgotPassword(sender: AnyObject) {

    }
    
    
}