//
//  MyJobTableViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 1/07/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import GoogleMaps


class MyJobTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let cellSpacingHeight: CGFloat = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setThemeUsingPrimaryColor(nil, withSecondaryColor: nil, andContentStyle: .contrast)
    
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.stopUpdatingLocation()
        
        
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
        //This is going to be a problem later
        //OI CUNT THIS IS GOING TO BE A PROBLEM
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        
        
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyJobTableCell", for: indexPath) as! MyJobTableCell
        
        cell.startTimeHour.text = "10pm"
        cell.startTimeMonth.text = "17th of August"
        cell.status.text = "Offer of Work Accepted"
        cell.profilePictureView.image = UIImage(named: "Callum")
        //cell.mapView.myLocationEnabled = true
        

        
        var camera:GMSCameraPosition = GMSCameraPosition()
        let long = locationManager.location?.coordinate.longitude
        let lat = locationManager.location?.coordinate.latitude
        
        if (long != nil && lat != nil){
            camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 14)
        } else {
            
            //This needs to be looked at later
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
        
        marker.title = "Mow Lawns"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = cell.mapView
    
        
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "MyJobsDetailSegue" {
            
        }
    }

}




