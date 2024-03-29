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
//import SwiftyJSON

class LoginViewController: UIViewController,FBSDKLoginButtonDelegate {
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    //TODO: This is actually really bad form having two copies of this... Sort this at some point
    
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
            if result.declinedPermissions.contains("email") {
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "We need your email address to proceed", message: "We can't set up your account with your email. Don't worry, we will not spam your inbox! We promise", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
                    // Handle cancellations
                    print("user is cancelled the login FB")
                    FBSDKLoginManager().logOut()
                    
                })
                let reRequestAction = UIAlertAction(title: "Grant Access", style: UIAlertActionStyle.default, handler: { action in
                    let fbsdklm = FBSDKLoginManager()
                    fbsdklm.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
                        if (error != nil){
                            // Process error
                            //print("Processing Error : \(error)")
                            FBSDKLoginManager().logOut()
                        } else if (result?.isCancelled)! {
                            // Handle cancellations
                            print("user is cancelled the login FB")
                            FBSDKLoginManager().logOut()
                        }
                        else {
                            print("Got Email Permissions!")
                            //proceed
                        }
                    }
                })
                
                alert.addAction(cancelAction)
                alert.addAction(reRequestAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
                UserDefaults.standard.set(user!.uid, forKey: "uid")
                
                guard let uid = user?.uid else {
                    return
                }
                
                let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large), work, education"])
                let connection = FBSDKGraphRequestConnection()
                
                connection.add(request,completionHandler: { (connection, result, error) in
                    if error == nil {
                        SVProgressHUD.show(withStatus: "Setting up your Profile with Facebook")
                        let info = result as? NSDictionary
                        
                        // Get the results out of the info Dictionary
                        // I don't think it will get here if there isn't values in this dictionary
                        // So going to leave the force unwrapping here for now.
                        let firstName = info?.value(forKey: "first_name") as? String
                        let lastName = info?.value(forKey: "last_name") as? String
                        let email = info?.value(forKey: "email") as? String
                        let id = info?.value(forKey: "id") as? String
                        let facebookProfilePictureURL = "https://graph.facebook.com/\(id!)/picture?type=large"
                        _ = info?.value(forKey: "education")
                        
                        //var json = JSON(education)
                        
                        //let length = json[].count - 1
                        
                        //Facebook Graph Api 2.8 puts the most current school/college at the end of the json array. This hack grabs the last one.
                        // Two types of nodes here. High School and College. 
                        // if only high school. get the top node.
                        // if both, get the top college node.
                        
//                        var school = ""
//                        var numberHighSchool: Int = 0
//                        var numberColleges: Int = 0
//                        for item in json[0].arrayValue {
//                            if item == "High School"{
//                                numberHighSchool + 1
//                                print("Added high school")
//                            } else {
//                                numberColleges + 1
//                                print("Added College")
//                            }
//                        }
//                        
//                        print(numberColleges)
//                        print(numberHighSchool)
//                        
//
//                        //If their is only high schools, grab the top node.
//                        if json[0]["type"].stringValue == "High School", json[length]["type"].stringValue == "High School"{
//                            if length == 1 {
//                                school = json[0]["school"]["name"].stringValue
//                            } else {
//                                school = json[length]["school"]["name"].stringValue
//                            }
//                            print("There is only high schools!")
//                            print(school)
//                        } else {
//                            //there are colleges and schools. Need to get the number of schools and then use that to get the top level
//                            if length == (1 + numberHighSchool) {
//                                school = json[0 + numberHighSchool]["school"]["name"].stringValue
//                            } else {
//                                school = json[length - numberHighSchool]["school"]["name"].stringValue
//                            }
//                            print("There is only high schools!")
//                            print(school)
//                        }
                        

                        
                        //Guard these.
                        self.storeImageFromFacebook(firstName: firstName!, lastName: lastName!, email: email!, profilePic: facebookProfilePictureURL, uid: uid)
                        
                    } else {
                        self.present(handleFirebaseAuthErrors(email: "", error: error!), animated: true, completion: nil)
                    }
                })
                connection.start()
                SVProgressHUD.dismiss()
                self.showMainTabScreen()
            }
        }
    }
    
    func storeImageFromFacebook(firstName: String, lastName: String, email: String, profilePic: String, uid: String){
        let storageRef = Storage.storage().reference().child("profile_images").child("\(uid)")
        //Dowloand the image
        SVProgressHUD.show(withStatus: "Getting your profile Picture")
        Alamofire.request(profilePic).responseImage { response in
            if let image = response.result.value {
                if let uploadData = UIImagePNGRepresentation(image){
                    
                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil{
                            SVProgressHUD.dismiss()
                            //print(error?.localizedDescription)
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
        facebookButton.readPermissions = ["email","user_education_history", "user_work_history"]
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
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
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
        try! Auth.auth().signOut()
    }
}
