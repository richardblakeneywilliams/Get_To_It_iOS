//
//  ToWorkController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 15/06/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import GoogleMaps

class ToWorkController: UIViewController {
    
    override func viewDidLoad() {
        let camera = GMSCameraPosition.cameraWithLatitude(-33.86,
                                                          longitude: 151.20, zoom: 6)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }

}
