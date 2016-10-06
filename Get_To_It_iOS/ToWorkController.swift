//
//  ToWorkController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 15/06/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import SwiftDate

class ToWorkController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {

        //Removes the blue theme from the Google logo in the bottom left corner.
        self.setThemeUsingPrimaryColor(nil, withSecondaryColor: nil, andContentStyle: .contrast)
        
        //Put this in a manager. More than one view needs it.
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        locationManager.distanceFilter = 10
        
        locationManager.startUpdatingLocation()
        
        let long = locationManager.location?.coordinate.longitude
        let lat = locationManager.location?.coordinate.latitude
        
        var camera:GMSCameraPosition = GMSCameraPosition()
        
        if (long != nil){
            camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 14)
        } else {
            camera = GMSCameraPosition.camera(withLatitude: 48.857165, longitude: 2.354613, zoom: 14)
        }
        
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        //mapView.myLocationEnabled = true
        mapView.settings.zoomGestures = true
        
        let marker = GMSMarker()
        
        
        if long != nil {
            marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        } else {
            marker.position = CLLocationCoordinate2D(latitude: 48.857165, longitude: 2.354613)
        }
        
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.icon = UIImage(named: "worker_spade")
        marker.map = mapView
        
        
        self.view = mapView
        
        
    }

}
