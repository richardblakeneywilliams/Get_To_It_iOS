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
import SVProgressHUD

class LoginViewController: UIViewController,FBSDKLoginButtonDelegate {
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    /*!
     @abstract Sent to the delegate when the button was used to login.
     @param loginButton the sender
     @param result The results of the login
     @param error The error (if any) from the login
     */
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        SVProgressHUD.show(withStatus: "Logging you in with Facebook..")
        if let error = error {
            SVProgressHUD.dismiss()
            //Handle the errors and present them to the user if necessary
            self.present(handleFacebookSDKErrors(error: error), animated: true, completion: nil)
            return
        } else if result.isCancelled{
            SVProgressHUD.dismiss()
            print("User cancelled login")
            FBSDKLoginManager().logOut()
        } else {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                UserDefaults.standard.set(user!.uid, forKey: "uid")
                
                guard let uid = user?.uid else {
                    return
                }
                
                let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"])
            
                
                request?.start(completionHandler: { (connection, result, error) in
                    if error == nil {
                        SVProgressHUD.show(withStatus: "Setting up your Profile with Facebook")
                        let info = result as? NSDictionary
                        
                        //Get the results out of the info Dictionary
                        let firstName = info?.value(forKey: "first_name") as? String
                        let lastName = info?.value(forKey: "last_name") as? String
                        let email = info?.value(forKey: "email") as? String
                        let id = info?.value(forKey: "id") as? String
                        let facebookProfilePictureURL = "https://graph.facebook.com/\(id!)/picture?type=large"
                        
                        self.storeImageFromFacebook(firstName: firstName!, lastName: lastName!, email: email!, profilePic: facebookProfilePictureURL, uid: uid)
                        
                    } else {
                        self.present(handleFirebaseAuthErrors(email: "", error: error!), animated: true, completion: nil)
                    }
                })
                SVProgressHUD.dismiss()
                self.showMainTabScreen()
            }
        }
    }
    
    func storeImageFromFacebook(firstName: String, lastName: String, email: String, profilePic: String, uid: String){
        let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(uid)")
        //Dowloand the image
        SVProgressHUD.show(withStatus: "Getting your profile Picture")
        Alamofire.request(profilePic).responseImage { response in
            if let image = response.result.value {
                if let uploadData = UIImagePNGRepresentation(image){
                    
                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil{
                            SVProgressHUD.dismiss()
                            print(error?.localizedDescription)
                            //Error Checking here.
                            return
                        } else {
                            SVProgressHUD.dismiss()
                            let workPlace = "" //TODO: Sort this.
                            //Register new user in Firebase.
                            registerUserIntoDatabaseWithUID(uid: uid, firstName: firstName, lastName: lastName, email: email, profileUrl: (metadata?.downloadURL()?.absoluteString)!
                                , workPlace: workPlace)
                        }
                    })
                } //if uploadData
            } //If image
        }// Alamofire request
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: MainTabViewController = (storyboard.instantiateViewController(withIdentifier: "mainTabbedScreen") as! MainTabViewController)
        present(viewController, animated: true, completion: nil)
    }
    
    //Email Login
    @IBAction func loginAction(_ sender: AnyObject) {
        SVProgressHUD.show(withStatus: "Logging you in")
        if let email = self.emailTextField.text, !email.isEmpty, let password = self.passwordTextField.text, !password.isEmpty {
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                
                if let error = error {
                    self.present(handleFirebaseAuthErrors(email: email, error: error), animated: true, completion: nil)
                } else {
                    SVProgressHUD.dismiss()
                    UserDefaults.standard.set(user!.uid, forKey: "uid")
                    self.showMainTabScreen()
                }
            }
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Error", message: "Enter Email & Password", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //Logout Facebook
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton) {
        try! FIRAuth.auth()!.signOut()
    }
}
