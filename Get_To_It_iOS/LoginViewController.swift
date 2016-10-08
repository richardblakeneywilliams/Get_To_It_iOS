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
import ChameleonFramework
import FBSDKCoreKit
import Alamofire
import AlamofireImage

class LoginViewController: UIViewController,FBSDKLoginButtonDelegate {
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    /*!
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
                
                guard let uid = user?.uid else {
                    return
                }

                //Making request to Facebook and getting profile information.
                let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"])
                request?.start(completionHandler: { (connection, result, error) in
                    if error == nil {
                        let info = result as? NSDictionary
                        
                        
                        //Get the results out of the info Dictionary
                        let firstName = info?.value(forKey: "first_name") as? String
                        let lastName = info?.value(forKey: "last_name") as? String
                        let email = info?.value(forKey: "email") as? String
                        let id = info?.value(forKey: "id") as? String
                        let profileURL = "https://graph.facebook.com/\(id!)/picture?type=large"
                        
                        let newUser : [AnyHashable: Any] =
                            ["firstName": firstName!,
                             "lastName": lastName!,
                             "email": email!,
                             "profileURL": profileURL]
                        
                        //Store the results in Firebase
                        _ = FIREBASE_REF.child("user").child(uid).setValue(newUser)
                        
                        let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(uid)")
                        
                        //Dowloand the image
                        
                        
                        
                        Alamofire.request(profileURL).responseImage { response in
                            if let image = response.result.value {
                                if let uploadData = UIImagePNGRepresentation(image){
                                    
                                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                                        
                                        if error != nil{
                                            print(error?.localizedDescription)
                                            return
                                        }
                                    })
                                }
                            }
                        }
                    } else {
                        print(error?.localizedDescription)
                    }
                })
            
                self.showMainTabScreen()
            }
        }
    }

    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setThemeUsingPrimaryColor(nil, withSecondaryColor: nil, andContentStyle: .contrast)
        
        self.loginButton.backgroundColor = .black        
        
        self.hideKeyboardWhenTappedAround()
        
        
        facebookButton.delegate = self
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
