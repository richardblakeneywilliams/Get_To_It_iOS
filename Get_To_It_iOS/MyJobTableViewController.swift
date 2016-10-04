//
//  MyJobTableViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 1/07/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import DZNEmptyDataSet
import SwiftDate


class MyJobTableViewController: UITableViewController, CLLocationManagerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    let locationManager = CLLocationManager()
    let cellSpacingHeight: CGFloat = 10
    
    var myjobs = [Job]()
    
    let nzTime = Region(tz: TimeZoneName.pacificAuckland, cal: CalendarName.gregorian, loc: LocaleName.english)

    // MARK: - Firebase
    
    //Function that returns the current jobs owned by the User and adds them to the myJobs Array
    func getCurrentJobs(){
        let userID = FIRAuth.auth()?.currentUser?.uid
        FIREBASE_REF.child("user-jobs").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get Job value
            let firebaseJobs = snapshot.value as? NSDictionary
            
            for(key,_) in firebaseJobs! {
                let job:NSObject = firebaseJobs![key] as! NSObject
                
                //Adds Firebase job to joblist.
                let address = job.value(forKey: "address") as? String
                let areTheyPresent = job.value(forKey: "areTheyPresent") as? Bool
                let category = job.value(forKey: "category") as? String
                let description = job.value(forKey: "description") as? String
                let jobEndTime = job.value(forKey: "jobEndTime") as! String
                let jobStartTime = job.value(forKey: "jobStartTime") as! String
                let latitude = job.value(forKey: "latitude") as? Double
                let longitude = job.value(forKey: "longitude") as? Double
                let numberOfHours = job.value(forKey: "numberOfHours") as? Int
                let subCategory = job.value(forKey: "subCategory") as? String
                let title = job.value(forKey: "title") as? String
                let toolsOnSite = job.value(forKey: "toolsOnSite") as? Bool
                let totalCost = job.value(forKey: "totalCost") as? Double
                let uid = job.value(forKey: "uid") as? String
                let status = job.value(forKey: "status") as? String

                
                //Dates should be converted from String to NSDate
                
                let newJob = Job(title: title!,
                                 description: description!,
                                 category: category!,
                                 subCategory: subCategory!,
                                 address: address!,
                                 long: longitude!,
                                 lat: latitude!,
                                 numberOfHours: numberOfHours!,
                                 jobStartTime: jobStartTime,
                                 jobEndTime: jobEndTime,
                                 toolsOnSite: toolsOnSite!,
                                 areTheyPresent: areTheyPresent!,
                                 totalCost: totalCost!,
                                 status: status!,
                                 uid: uid!)
                
                self.myjobs.append(newJob)
                self.tableView.reloadData()

            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentJobs()
        
        self.setThemeUsingPrimaryColor(nil, withSecondaryColor: nil, andContentStyle: .contrast)
        
        //For Empty Data set stuff.
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.stopUpdatingLocation()
        
        tableView.reloadData()
    }
    
    

    
    //Image returned as part of the empty data set.
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "Spade")
    }
    
    //Attributed Title returned as part of the empty data set.
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        let text = "You have no current jobs"
        let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18.0), NSForegroundColorAttributeName: UIColor.darkGray]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    //Description for Empty Data Set
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "You need to create or do a job for it to pop up on this list"
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0), NSForegroundColorAttributeName: UIColor.lightGray, NSParagraphStyleAttributeName: paragraph]
        return NSAttributedString(string: text, attributes: attributes)
    }

    
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myjobs.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyJobTableCell", for: indexPath) as! MyJobTableCell
        
        print("here")
        
        cell.startTimeHour.text = self.myjobs[indexPath.row].title
        cell.startTimeMonth.text = self.myjobs[indexPath.row].jobStartTime
        cell.status.text = self.myjobs[indexPath.row].status
        cell.profilePictureView.image = UIImage(named: "DefaultProfilePicture")
        
        var camera:GMSCameraPosition = GMSCameraPosition()
        let long = self.myjobs[indexPath.row].long
        let lat = self.myjobs[indexPath.row].lat
        
        if (long != nil && lat != nil){
            camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 14)
        } else {
            
            //This needs to be looked at later.
            camera = GMSCameraPosition.camera(withLatitude: 48.857165, longitude: 2.354613, zoom: 14)
        }
        
        cell.mapView.camera = camera
        let marker: GMSMarker = GMSMarker()
        
        
        if (long != nil && lat != nil){
            marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        } else {
            //This needs to be looked at later
            marker.position = CLLocationCoordinate2D(latitude: 48.857165, longitude: 2.354613)
        }
        
        marker.title = self.myjobs[indexPath.row].title
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = cell.mapView
        return cell
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "toOverViewController" {
//            let dc = segue.destinationViewController as! OverviewViewController
//            dc.hidesBottomBarWhenPushed = true
//            
//        }
//    }

}




