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
            
            // Get Job value and populate the table if their is data. Else just leave it empty.
            if let firebaseJobs = snapshot.value as? NSDictionary {
            for(key,_) in firebaseJobs {
                let job:NSObject = firebaseJobs[key] as! NSObject
                
                
                //Adds Firebase job to joblist.
                let address = job.value(forKey: "address") as? String
                let areTheyPresent = job.value(forKey: "areTheyPresent") as? Bool
                let category = job.value(forKey: "category") as? String
                let description = job.value(forKey: "description") as? String
                let jobEndTime = job.value(forKey: "jobEndTime") as? Double
                let jobStartTime = job.value(forKey: "jobStartTime") as? Double
                let latitude = job.value(forKey: "latitude") as? Double
                let longitude = job.value(forKey: "longitude") as? Double
                let numberOfHours = job.value(forKey: "numberOfHours") as? Int
                let subCategory = job.value(forKey: "subCategory") as? String
                let title = job.value(forKey: "title") as? String
                let toolsOnSite = job.value(forKey: "toolsOnSite") as? Bool
                let totalCost = job.value(forKey: "totalCost") as? Double
                
                let uid = job.value(forKey: "uid") as? String
                
                let status = job.value(forKey: "status") as? String
                
                
                //TODO: Insert unwrapping checks on all values... Show empty map/Empty shit if information is incomplete. THIS IS TO DANGEROUS IN ITS CURRENT STATE.
                
                
                let newJob = Job(title: title!,
                                 description: description!,
                                 category: category!,
                                 subCategory: subCategory!,
                                 address: address!,
                                 long: longitude!,
                                 lat: latitude!,
                                 numberOfHours: numberOfHours!,
                                 jobStartTime: jobStartTime!,
                                 jobEndTime: jobEndTime!,
                                 toolsOnSite: toolsOnSite!,
                                 areTheyPresent: areTheyPresent!,
                                 totalCost: totalCost!,
                                 status: status!,
                                 uid: uid!)
                
                
                self.myjobs.append(newJob)
                
                self.tableView.reloadData()
                
            }
            
            } else {
                print("No jobs")
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
        //This gets rid of lines in the tableview when its empty.
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
        
        //TODO: Google shit here.
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myjobs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyJobTableCell", for: indexPath) as! MyJobTableCell
        
        //New NSDate From the Interval. 
        
        let startTimeDate = Date(timeIntervalSince1970: self.myjobs[indexPath.row].jobStartTime!)

        //Date Formatter to get the right string from the date
        let Hourformatter = DateFormatter()
        Hourformatter.dateFormat = "h:mm a"
        Hourformatter.amSymbol = "am"
        Hourformatter.pmSymbol = "pm"
        Hourformatter.timeZone = NSTimeZone.local
        
        cell.startTimeHour.text = Hourformatter.string(from: startTimeDate)

        //Date Formatter to get the right string from the date
        let Monthformatter = DateFormatter()
        Monthformatter.dateFormat = "dd MMMM yyyy"
        Monthformatter.amSymbol = "am"
        Monthformatter.pmSymbol = "pm"
        Monthformatter.timeZone = NSTimeZone.local
        
        cell.startTimeMonth.text = Monthformatter.string(from: startTimeDate)
        
        cell.status.text = self.myjobs[indexPath.row].status
        cell.profilePictureView.image = UIImage(named: "DefaultProfilePic")
        
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
        cell.mapView.settings.setAllGesturesEnabled(false)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReloadVC" {
            
            //Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row{
                let dc = segue.destination as! ReloadExampleViewController
                
                //Change navigation title label to the name of the job.
                dc.titleLabel.text = self.myjobs[row].title

                
            }
        }
    }

}




