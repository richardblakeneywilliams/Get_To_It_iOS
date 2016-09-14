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
    /*!
     //Facebook Login Shit
     @abstract Sent to the delegate when the button was used to login.
     @param loginButton the sender
     @param result The results of the login
     @param error The error (if any) from the login
     */
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        } else {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                UserDefaults.standard.set(user!.uid, forKey: "uid")
                self.showMainTabScreen()
            }
        }
    }

    
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    func showMainTabScreen(){
        // Get main screen from storyboard and present it
        print("showTabScreen")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: MainTabViewController = (storyboard.instantiateViewController(withIdentifier: "mainTabbedScreen") as! MainTabViewController)
        present(viewController, animated: true, completion: nil)
    }
    
    //Email Login
    @IBAction func loginAction(_ sender: AnyObject) {
        if let email = self.emailTextField.text, let password = self.passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    UserDefaults.standard.set(user!.uid, forKey: "uid")
                    print("Logged In")
                    self.showMainTabScreen()
                }
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter Email and Password.", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Logout Facebook
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton) {
        try! FIRAuth.auth()!.signOut()
    }
    
    @IBAction func forgotPassword(_ sender: AnyObject) {

    }
    
    
}
