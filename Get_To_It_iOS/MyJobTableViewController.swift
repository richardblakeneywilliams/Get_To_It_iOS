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
    
    //var myJobsArray
    //I need to add the ComsManager downloading the User_jobs table. Do I need to add a User_Jobs_Created/User_Jobs_Working?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //This is going to be a problem later
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyJobTableCell", forIndexPath: indexPath) as! MyJobTableCell
        cell.categoryText.text = "Gardening"
        cell.CategoryImageView.image = UIImage(named: "Gardening")
        cell.employerName.text = "John Yates"
        cell.employerProfilePic.image = UIImage(named: "Callum")
        cell.titleLabel.text = "Trimmed the hedges"
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "MyJobsDetailSegue" {
            
        }
    }

}




