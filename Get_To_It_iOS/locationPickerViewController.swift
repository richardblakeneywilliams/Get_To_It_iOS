
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
    
    
    override func viewDidLoad() {
        
        self.setThemeUsingPrimaryColor(nil, withSecondaryColor: nil, andContentStyle: .contrast)
        
        
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
            camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 18)
        } else {
            camera = GMSCameraPosition.camera(withLatitude: 48.857165, longitude: 2.354613, zoom: 18)
        }
        
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.settings.setAllGesturesEnabled(true)
        mapView.settings.myLocationButton = true
    }
    
    
    // Present the Autocomplete view controller when the button is pressed.
    func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        autocompleteClicked()
    }

    
    @IBAction func backButton(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LocationSegue" {
            print(CurrentJob.instance?.lat)
            print(CurrentJob.instance?.long)
            print(CurrentJob.instance?.address)
        }
    }
}





extension locationPickerViewController: GMSAutocompleteViewControllerDelegate {
    /**
     * Called when a non-retryable error occurred when retrieving autocomplete predictions or place
     * details. A non-retryable error is defined as one that is unlikely to be fixed by immediately
     * retrying the operation.
     * <p>
     * Only the following values of |GMSPlacesErrorCode| are retryable:
     * <ul>
     * <li>kGMSPlacesNetworkError
     * <li>kGMSPlacesServerError
     * <li>kGMSPlacesInternalError
     * </ul>
     * All other error codes are non-retryable.
     * @param viewController The |GMSAutocompleteViewController| that generated the event.
     * @param error The |NSError| that was returned.
     */
    public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }

    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        kLocationTextField.text = place.formattedAddress
        
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,
                                                          longitude: place.coordinate.longitude, zoom: 18)
        mapView.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(place.coordinate.latitude,place.coordinate.longitude)
        marker.title = place.name
        marker.snippet = place.formattedAddress
        marker.map = mapView
        
        CurrentJob.instance?.long = place.coordinate.longitude
        CurrentJob.instance?.lat = place.coordinate.latitude
        CurrentJob.instance?.address = place.formattedAddress as NSString?
        
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
        

        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
