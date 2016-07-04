//
//  MyJobTableViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 1/07/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import GoogleMaps


class MyJobTableViewController: UITableViewController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("never easy is it!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("never easy is it!")

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("never easy is it!")

        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MyJobTableCell", forIndexPath: indexPath) as! MyJobTableCell
        print("never easy is it!")
        cell.categoryText.text = "Gardening"
        cell.CategoryImageView.image = UIImage(named: "Gardening")
        cell.employerName.text = "John Yates"
        cell.employerProfilePic.image = UIImage(named: "Callum")
        cell.titleLabel.text = "Trimmed the hedges"
        
        return cell
    }

}




