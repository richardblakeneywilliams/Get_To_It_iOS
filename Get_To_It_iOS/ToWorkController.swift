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


class ToWorkController: UIViewController, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        
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
        
        //Fix this later
        let camera = GMSCameraPosition.cameraWithLatitude(lat!,
                                                          longitude: long!, zoom: 15)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        mapView.settings.zoomGestures = true
        self.view = mapView
        
    }

}
