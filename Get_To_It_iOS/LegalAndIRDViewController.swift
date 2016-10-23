//
//  LegalAndIRDViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 15/10/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LegalAndIRDViewController: UIViewController {
    
    @IBOutlet weak var irdNumberTextField: UITextField!
    @IBOutlet weak var validVisaSwitch: UISwitch!
    @IBOutlet weak var citizenSwitch: UISwitch!
    @IBOutlet weak var bankAccountTextField: UITextField!
    
    
    @IBOutlet weak var getToItButton: UIButton!
    
    
    
    //MARK: - Firebase
    @IBAction func loadWorkerOnboardingInfo(_ sender: AnyObject) {
        if let ird = self.irdNumberTextField.text, !ird.isEmpty, let bank = self.bankAccountTextField.text, !bank.isEmpty {
            if citizenSwitch.isOn, validVisaSwitch.isOn{
                uploadOnboardingToUser(ird: irdNumberTextField.text!, bankAcc: bankAccountTextField.text!, nZCit: true, visa: true)
                showMainTabScreen()
            } else{
                let alert = UIAlertController(title: "Error", message: "You must have a valid visa and be entitled to work in NZ to use Get To It", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
            
            //Check if this has been successful. If so, then push main tab. Else, notify the user and prevent a crash!
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter your work info!", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getToItButton.backgroundColor = .black
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMainTabScreen(){
        // Get main screen from storyboard and present it
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: MainTabViewController = (storyboard.instantiateViewController(withIdentifier: "mainTabbedScreen") as! MainTabViewController)
        present(viewController, animated: true, completion: nil)
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
