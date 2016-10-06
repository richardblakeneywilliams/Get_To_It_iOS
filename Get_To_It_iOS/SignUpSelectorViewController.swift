//
//  SignUpSelectorViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 6/10/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SignUpSelectorViewController: UIViewController {
    @IBOutlet weak var signUpEmailButton: UIButton!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        signUpEmailButton.backgroundColor = .black

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
