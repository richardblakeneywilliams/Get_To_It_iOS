//
//  ResetPasswordViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 12/10/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var sendResetEmailButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendResetEmailButton.backgroundColor = .black
        emailTextField.text = nil
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendResetEmail(_ sender: AnyObject) {
        if let email = emailTextField.text , !email.isEmpty{
            FIRAuth.auth()?.sendPasswordReset(withEmail: email) { error in
                
                var alertDescription: String = ""
                
                if error != nil {
                    
                    if let errCode = FIRAuthErrorCode(rawValue: error!._code){
                        
                        switch errCode {
                        case .errorCodeUserNotFound:
                            alertDescription = "Email: \(email) was not found in the system"
                        case .errorCodeInvalidEmail:
                            alertDescription = "invalid email"
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
                    
                    //What about no net? Can I catch that here...
                    print(error?.localizedDescription)
                    let alertController = UIAlertController(title: "Error", message: alertDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController .addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    // Password reset email sent.
                    let alertController = UIAlertController(title: "Password reset email sent", message: "To \(email)", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController .addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }
        } else {
            //Alert the user that they didn't enter an email!
            let alertController = UIAlertController(title: "Please Enter an Email!", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController .addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }

    }
}


