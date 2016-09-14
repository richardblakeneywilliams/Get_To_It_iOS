//
//  MoreViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 30/06/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import Eureka
//import ChameleonFramework

class MoreViewController: FormViewController {  //FormViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setThemeUsingPrimaryColor(nil, withSecondaryColor: nil, andContentStyle: .Contrast)
        
    
    
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        }
        
        form =
    
            Section() {
                $0.header = HeaderFooterView<ProfileImageView>(HeaderFooterProvider.class)
            }
    
            <<< ButtonRow("Account Settings") {
                $0.title = $0.tag
                $0.presentationMode = .segueName(segueName: "AccountSettingsSegue", completionCallback: nil)
            }
    
            <<< ButtonRow("My Money") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "MyMoneySegue", completionCallback: nil)
            }
    
            <<< ButtonRow("Past Jobs") { (row: ButtonRow) in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "PastJobsSegue", completionCallback: nil)
            }
    
    
            <<< ButtonRow("Payment") { (row: ButtonRow) -> Void in
                row.title = row.tag
    
                row.presentationMode = .segueName(segueName: "PaymentSegue", completionCallback: nil)
            }
    
            <<< ButtonRow("Settings") { (row: ButtonRow) -> Void in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "SettingsSegue", completionCallback: nil)
            }
    
    
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "About"
                }  .onCellSelection({ (cell, row) in
                    print("lol")
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





