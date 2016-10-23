//
//  Messages Controller.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 13/10/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet

class MessagesController: UITableViewController{
    
    var messageThreads = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Firebase
    
    //Fetch users from Db. For now just fetch all the users.
    
    
    
    
    // MARK: - Empty Data Set
    
    //Image returned as part of the empty data set.
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "Spade")
    }
    
    //Attributed Title returned as part of the empty data set.
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        let text = "You have no messaging open"
        let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18.0), NSForegroundColorAttributeName: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    //Description for Empty Data Set
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "You need to start"
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0), NSForegroundColorAttributeName: UIColor.lightGray, NSParagraphStyleAttributeName: paragraph]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    
    
    // MARK: TableViewController
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageThreads.count
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        
//    }
//    
    
}


class UserMessageThreadCell: UITableViewCell {
    
    
}


