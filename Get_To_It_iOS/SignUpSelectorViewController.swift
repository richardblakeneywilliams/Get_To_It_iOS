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

class SignUpSelectorViewController: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var signUpEmailButton: UIButton!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        facebookButton.delegate = self
        signUpEmailButton.backgroundColor = .black

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
            SVProgressHUD.show(withStatus: "Logging you in with Facebook..")
            if let error = error {
                SVProgressHUD.dismiss()
                print(error.localizedDescription)
                return
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
                            
                            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(uid)")
                            
                            //Dowloand the image
                            SVProgressHUD.show(withStatus: "Getting your profile Picture")
                            Alamofire.request(facebookProfilePictureURL).responseImage { response in
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
                                                //Force Upwrapping here.
                                                registerUserIntoDatabaseWithUID(uid: (user?.uid)!, firstName: firstName!, lastName: lastName!, email: email!, profileUrl: (metadata?.downloadURL()?.absoluteString)!
                                                    , workPlace: workPlace)
                                                
                                                
                                            }
                                        })
                                    } //if uploadData
                                } //If image
                            }// Alamofire request
                        } else {
                            self.present(handleFirebaseAuthErrors(email: "", error: error!), animated: true, completion: nil)
                        }
                    })
                    SVProgressHUD.dismiss()
                    self.showMainTabScreen()
                }
            }
    }
    
    func showMainTabScreen(){
        // Get main screen from storyboard and present it
        print("showTabScreen")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: MainTabViewController = (storyboard.instantiateViewController(withIdentifier: "mainTabbedScreen") as! MainTabViewController)
        present(viewController, animated: true, completion: nil)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()!.signOut()
    }

}
