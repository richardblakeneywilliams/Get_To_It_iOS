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
                if error != nil {
                    // An error happened.
                    
                } else {
                    // Password reset email sent.
                    let alertController = UIAlertController(title: "Password reset email sent", message: "", preferredStyle: .alert)
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


