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
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.stopUpdatingLocation()
        
        let long = locationManager.location?.coordinate.longitude
        let lat = locationManager.location?.coordinate.latitude
        
        let camera = GMSCameraPosition.cameraWithLatitude(lat!,
                                                          longitude: long!, zoom: 18)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        mapView.settings.zoomGestures = true
        mapView.settings.myLocationButton = true
        self.view = mapView
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-38.7045423,176.0346538)
        marker.title = "Taupo"
        marker.snippet = "New Zealand"
        marker.map = mapView
    }

}
