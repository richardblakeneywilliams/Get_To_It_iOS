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
import FirebaseStorage
import FirebaseDatabase

class MoreViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setThemeUsingPrimaryColor(nil, withSecondaryColor: nil, andContentStyle: .contrast)
        
        
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
                    let viewController: NavController = (storyboard.instantiateViewController(withIdentifier: "NavController") as! NavController)
                    self.present(viewController, animated: true, completion: {
                        try! FIRAuth.auth()!.signOut()
                        let loginManger = FBSDKLoginManager()
                        loginManger.logOut()
                    })
                })
    }
}

    
    
    class ProfileImageView: UIView {
        
        override func awakeFromNib() {
            self.setNeedsDisplay()
        }
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            let imageView = UIImageView()
            let nameLabel: UILabel = UILabel()
            
            FIRAuth.auth()?.addStateDidChangeListener { auth, user in
                if let user = user {
                    // User is signed in.
                    if let profileURL = user.photoURL?.absoluteString{
                        imageView.loadImageUsingCacheWithUrlString(urlString: profileURL)
                    } else {
                        print("Fuck up with the image loading")
                    }
                    if let name = user.displayName {
                        nameLabel.text = name
                    } else {
                        print("Name didn't load")
                    }
                } else {
                    print("No user is signed in")
                    // No user is signed in.
                }
            }
            
            imageView.layer.cornerRadius = 40
            imageView.layer.masksToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill

            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.textAlignment = .center
            nameLabel.frame = CGRect(x: 0, y: 0, width: 320, height: 20)
            
            self.frame = CGRect(x: 0, y: 0, width: 320, height: 130)
            
            
            self.addSubview(imageView)
            self.addSubview(nameLabel)

            //Centre the image
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: self.topAnchor,constant: 90).isActive = true
            
            //Centre the name
            nameLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor,constant: 100).isActive = true
            nameLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
            
            //Make Height and Width equal 80.
            imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            //Centre the text label
            NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 1).isActive = true
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
            
        }
    }






