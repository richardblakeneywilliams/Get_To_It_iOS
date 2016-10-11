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
                // This whole thing needs to go in create account
                // Should this stay here?? Means if someone signs up in the wrong place, its fine.. 
                // This should go into a method because its going to be used twice. 
                // Making request to Facebook and getting profile information.
                let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"])
                request?.start(completionHandler: { (connection, result, error) in
                    if error == nil {
                        let info = result as? NSDictionary
                        
                        
                        //Get the results out of the info Dictionary
                        let firstName = info?.value(forKey: "first_name") as? String
                        let lastName = info?.value(forKey: "last_name") as? String
                        let email = info?.value(forKey: "email") as? String
                        let id = info?.value(forKey: "id") as? String
                        let facebookProfilePictureURL = "https://graph.facebook.com/\(id!)/picture?type=large"

                        
                        let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(uid)")
                        
                        //Dowloand the image
                        Alamofire.request(facebookProfilePictureURL).responseImage { response in
                            if let image = response.result.value {
                                if let uploadData = UIImagePNGRepresentation(image){
                                    
                                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                                        
                                        if error != nil{
                                            print(error?.localizedDescription)
                                            //Error Checking here.
                                            return
                                        } else {
                                            
                                            //Change the profile pic in Firebase. This code is bullshit.
                                            changeProfilePic(photoURL: (metadata?.downloadURL()?.absoluteString)!)

                                            let workPlace = ""
                                            //Register new user in Firebase.
                                            //Force Upwrapping here.
                                            registerUserIntoDatabaseWithUID(uid: (user?.uid)!, firstName: firstName!, lastName: lastName!, email: email!, profileUrl: (metadata?.downloadURL()?.absoluteString)!
                                                , workPlace: workPlace)
                                            
                                            
                                        }
                                    })
                                } //if uploadData
                            } //If image
                        }// Alamofire request
                    } else {
                        print(error?.localizedDescription)
                    }
                })
            
                self.showMainTabScreen()
            }
        }
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
        print("showTabScreen")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: MainTabViewController = (storyboard.instantiateViewController(withIdentifier: "mainTabbedScreen") as! MainTabViewController)
        present(viewController, animated: true, completion: nil)
    }
    
    //Email Login
    @IBAction func loginAction(_ sender: AnyObject) {
        SVProgressHUD.show(withStatus: "Logging you in")
        if let email = self.emailTextField.text, !email.isEmpty, let password = self.passwordTextField.text, !password.isEmpty {
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                var alertDescription: String = ""
                
                if let error = error {
                    SVProgressHUD.dismiss()
                    
                    //Deal with all the fucking errors.
                    if let errCode = FIRAuthErrorCode(rawValue: error._code){
                        
                        switch errCode {
                        case .errorCodeWrongPassword:
                            alertDescription = "Wrong password!"
                        case .errorCodeUserNotFound:
                            alertDescription = "Email: \(email) was not found in the system"
                        case .errorCodeInvalidEmail:
                            alertDescription = "Invalid email, please enter a registered or correct one."
                        case .errorCodeEmailAlreadyInUse:
                            alertDescription = "Email is already in use, try another or log in with it"
                        case .errorCodeAccountExistsWithDifferentCredential:
                            alertDescription = "This email is already been used to register to Get To It. Its possible you used Facebook to sign up!"
                        case .errorCodeNetworkError:
                            alertDescription = "No Connection, try re-connecting to the internet!"
                        case .errorCodeUserDisabled:
                            alertDescription = "This account has been disabled. Contact Get To It"
                        default:
                            print("Create User Error: \(error)")
                        }
                    }
                    
                    let alertController = UIAlertController(title: "Error", message: alertDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController .addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    SVProgressHUD.dismiss()
                    UserDefaults.standard.set(user!.uid, forKey: "uid")
                    self.showMainTabScreen()
                }
            }
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Error", message: "Enter Email", preferredStyle: UIAlertControllerStyle.alert)
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
