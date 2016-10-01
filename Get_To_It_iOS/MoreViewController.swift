//
//  MoreViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 30/06/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import Eureka
import ChameleonFramework
import FirebaseAuth
import FBSDKLoginKit

class MoreViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setThemeUsingPrimaryColor(nil, withSecondaryColor: nil, andContentStyle: .contrast)
        
        
//        ImageRow.defaultCellUpdate = { cell, row in
//            cell.accessoryView?.layer.cornerRadius = 17
//            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
//        }
        
        form =
            
            Section() {
                $0.header = HeaderFooterView<ProfileImageView>(HeaderFooterProvider.class)
            }
            
            <<< ButtonRow("Account Settings") {
                $0.title = $0.tag
                $0.presentationMode = .segueName(segueName: "AccountSettingsSegue", onDismiss: nil)
            }
            
            <<< ButtonRow("My Money") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "MyMoneySegue", onDismiss: nil)
            }
            
            <<< ButtonRow("Past Jobs") { (row: ButtonRow) in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "PastJobsSegue", onDismiss: nil)
            }
            
            
            <<< ButtonRow("Payment") { (row: ButtonRow) -> Void in
                row.title = row.tag
                
                row.presentationMode = .segueName(segueName: "PaymentSegue", onDismiss: nil)
            }
            
            <<< ButtonRow("Settings") { (row: ButtonRow) -> Void in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "SettingsSegue", onDismiss: nil)
            }
            
            
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "About"
                }  .onCellSelection({ (cell, row) in
                    print("lol")
                })
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Log Out"
                }  .onCellSelection({ (cell, row) in
                    
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let viewController: LoginViewController = (storyboard.instantiateViewController(withIdentifier: "loginScreen") as! LoginViewController)
                    self.present(viewController, animated: true, completion: {
                        print("Logged out I hope...")
                        try! FIRAuth.auth()!.signOut()
                        let loginManger = FBSDKLoginManager()
                        loginManger.logOut()
                    })
                })
    }



class ProfileImageView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        let imageView = UIImageView(image: UIImage(named: "DefaultProfilePic"))
        imageView.frame = CGRect(x: 139, y: 16, width: 80, height: 80)
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        
        
        //TODO FIX THIS with fucking contraints later
        let name: UILabel = UILabel()
        name.text = "Richard Blakeney-Williams"
        name.frame = CGRect(x: 88, y: 96, width: 220, height: 21)
        
        self.frame = CGRect(x: 0, y: 0, width: 320, height: 130)
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        self.addSubview(name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    
    }
}
}





