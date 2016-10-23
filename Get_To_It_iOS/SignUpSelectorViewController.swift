//
//  SignUpSelectorViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 6/10/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import AlamofireImage
import SVProgressHUD
import Alamofire

class SignUpSelectorViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var signUpEmailButton: UIButton!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        facebookButton.delegate = self
        facebookButton.readPermissions = ["email"]

        signUpEmailButton.backgroundColor = .black //There is a bug in Xcode.

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
                            print("Processing Error : \(error)")
                            FBSDKLoginManager().logOut()
                        } else if (result?.isCancelled)! {
                            // Handle cancellations
                            print("user is cancelled the login FB")
                            FBSDKLoginManager().logOut()
                        }
                        else {
                            print("Got Email Permissions!")
                            //Success
                            
            
                            //proceed
                        }
                    }
                })
                
                alert.addAction(cancelAction)
                alert.addAction(reRequestAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                UserDefaults.standard.set(user!.uid, forKey: "uid")
                
                guard let uid = user?.uid else {
                    return
                }
                
                let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"])
                let connection = FBSDKGraphRequestConnection()
                
                connection.add(request,completionHandler: { (connection, result, error) in
                    if error == nil {
                        //Success
                        
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
                        
                        self.storeImageFromFacebook(firstName: firstName!, lastName: lastName!, email: email!, profilePic: facebookProfilePictureURL, uid: uid)
                        self.pushOnBoarding()
                        
                    } else {
                        self.present(handleFirebaseAuthErrors(email: "", error: error!), animated: true, completion: nil)
                    }
                })
                connection.start()
                SVProgressHUD.dismiss()
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
    
    func pushOnBoarding(){
        if let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "TypeOfWorkerViewController") as? TypeOfWorkerViewController {
            if let navigator = navigationController {
                navigator.pushViewController(vc, animated: true)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()!.signOut()
    }
    
    
    

}
