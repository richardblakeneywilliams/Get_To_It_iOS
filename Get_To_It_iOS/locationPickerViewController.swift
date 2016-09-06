
//
//  locationPickerViewController.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 24/06/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import ChameleonFramework
import GooglePlaces
import GooglePlacePicker

class locationPickerViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var kLocationTextField: UITextField!
    
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        //This created a new bug
//        LocationManager.instance.subscribeToUserLocation() { (userLocation) in
//            let camera = GMSCameraPosition.cameraWithLatitude(userLocation.coordinate.latitude,
//                longitude: userLocation.coordinate.longitude, zoom: 15)
//            
//            print("Location Picker, inside sub")
//            
//            self.mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
//            self.mapView.myLocationEnabled = true //This is in the wrong place.
//            self.mapView.settings.zoomGestures = true
//            self.mapView.settings.myLocationButton = true
//            
//            //Here is the issue. But is it?
//            //self.view = self.mapView
//            
//        }
//    }
    
    
    override func viewDidLoad() {
        
        self.setThemeUsingPrimaryColor(nil, withSecondaryColor: nil, andContentStyle: .Contrast)
        
        
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.stopUpdatingLocation()
        
        let long = locationManager.location?.coordinate.longitude
        let lat = locationManager.location?.coordinate.latitude
        
        var camera:GMSCameraPosition = GMSCameraPosition()
        
        if (long != nil){
            camera = GMSCameraPosition.cameraWithLatitude(lat!, longitude: long!, zoom: 18)
        } else {
            camera = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: 18)
        }
        mapView.camera = camera
        mapView.myLocationEnabled = true
        mapView.settings.setAllGesturesEnabled(true)
        mapView.settings.myLocationButton = true
    }
    
//    override func viewWillDisappear(animated: Bool) {
//        LocationManager.instance.removeLastListener()
//    }
    
    // Present the Autocomplete view controller when the button is pressed.
    func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.presentViewController(autocompleteController, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        autocompleteClicked()
    }

    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LocationSegue" {
            print(CurrentJob.instance?.lat)
            print(CurrentJob.instance?.long)
            print(CurrentJob.instance?.address)
        }
    }
}





extension locationPickerViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        kLocationTextField.text = place.formattedAddress
        
        
        let camera = GMSCameraPosition.cameraWithLatitude(place.coordinate.latitude,
                                                          longitude: place.coordinate.longitude, zoom: 18)
        mapView.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(place.coordinate.latitude,place.coordinate.longitude)
        marker.title = place.name
        marker.snippet = place.formattedAddress
        marker.map = mapView
        
        CurrentJob.instance?.long = place.coordinate.longitude
        CurrentJob.instance?.lat = place.coordinate.latitude
        CurrentJob.instance?.address = place.formattedAddress
        
        if let long = CurrentJob.instance?.long{
            print(long)
        } else {
            print("No longitute")
        }
        
        if let lat = CurrentJob.instance?.lat{
            print(lat)
        } else {
            print("No latitude")
        }
        
        if let address = CurrentJob.instance?.address {
            print(address)
        }  else {
            print("No address")
        }
        

        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // User canceled the operation.
    func wasCancelled(viewController: GMSAutocompleteViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}
