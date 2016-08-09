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
    var mapView: GMSMapView! = nil
    
    override func viewDidLoad() {
        
        LocationManager.instance.subscribeToUserLocation() { (userLocation) in
            let camera = GMSCameraPosition.cameraWithLatitude(userLocation.coordinate.latitude,
                longitude: userLocation.coordinate.longitude, zoom: 15)
            self.mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
            //self.mapView.myLocationEnabled = true
            self.mapView.settings.zoomGestures = true
            self.mapView.settings.myLocationButton = true
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            marker.appearAnimation = kGMSMarkerAnimationPop //-  The fuck is this cunt
            marker.icon = UIImage(named: "worker_spade") // I have to fix this. Make this icon WAY smaller. 
            marker.map = self.mapView
            
            self.view = self.mapView
            
        }
        
        
        
        
//        //Put this in a manager. More than one view needs it. 
//        let locationManager = CLLocationManager()
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestWhenInUseAuthorization()
//        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        
//        locationManager.distanceFilter = 10
//        
//        locationManager.startUpdatingLocation()
        
        //This isn't fucking right cunt. Add me to a fucking service
//        let long = locationManager.location?.coordinate.longitude
//        let lat = locationManager.location?.coordinate.latitude
        
        //Fix this later
//        let camera = GMSCameraPosition.cameraWithLatitude(lat!,
//                                                          longitude: long!, zoom: 15)
//        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
//        mapView.myLocationEnabled = true
//        mapView.settings.zoomGestures = true
        
        

        
    }

}
