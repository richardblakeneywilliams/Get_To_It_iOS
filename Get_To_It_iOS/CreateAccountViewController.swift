//
//  CreateAccountViewController.swift
//  Get_To_It_iOS
//
//  Created by Richard Blakeney-Williams on 4/05/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func createAccountAction(_ sender: AnyObject) {
        if let email = self.emailTextField.text, let password = self.passwordTextField.text, let name = self.firstNameField.text {
        
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    let changeRequest = user?.profileChangeRequest()
                    changeRequest?.displayName = name
                    UserDefaults.standard.setValue(user!.uid, forKey: "uid")
                    UserDefaults.standard.synchronize()
                    print("Account Created :) for \(user?.displayName)")
                    self.dismiss(animated: true,completion: nil)
                }
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter Email and Password.", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
//    func setDisplayName(user: FIRUser) {
//        
//        let changeRequest = user.profileChangeRequest()
//        changeRequest.displayName = user.email!.componentsSeparatedByString("@")[0]
//        changeRequest.commitChangesWithCompletion(){ (error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            //self.signedIn(FIRAuth.auth()?.currentUser)
//        }
//    }

    
    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)

    }
    

}
