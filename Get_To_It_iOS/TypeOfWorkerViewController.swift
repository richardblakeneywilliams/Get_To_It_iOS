//
//  TypeOfWorkerViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 14/10/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit

class TypeOfWorkerViewController: UIViewController {

    @IBOutlet weak var employerButton: UIButton!
    @IBOutlet weak var workerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Your Role"
                
        workerButton.backgroundColor = .black
        employerButton.titleLabel?.textColor = .white
        
        employerButton.backgroundColor = UIColor(red:0.28, green:0.67, blue:0.89, alpha:1.0)
        workerButton.titleLabel?.textColor = .white
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Push the main area so they can start looking around and doing shit
    @IBAction func employerButtonPressed(_ sender: AnyObject) {
        showMainTabScreen()
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
