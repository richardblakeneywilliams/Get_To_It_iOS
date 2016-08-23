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
    
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        //Removes the blue theme from the Google logo in the bottom left corner.
        self.setThemeUsingPrimaryColor(nil, withSecondaryColor: nil, andContentStyle: .Contrast)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        LocationManager.instance.subscribeToUserLocation() { (userLocation) in
            let camera = GMSCameraPosition.cameraWithLatitude(userLocation.coordinate.latitude,
                longitude: userLocation.coordinate.longitude, zoom: 15)
            self.mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
            //self.mapView.myLocationEnabled = true
            self.mapView.settings.zoomGestures = true
            self.mapView.settings.myLocationButton = true
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.icon = UIImage(named: "worker_spade")
            //marker.
            marker.map = self.mapView
            
            //self.view = self.mapView
        }
    }
    
   override func viewWillDisappear(animated: Bool) {
        LocationManager.instance.removeLastListener()
    }

}
