//
//  LocationManager.swift
//  Get To It
//
//  Created by Richard Blakeney-Williams on 09/08/16.
//  Copyright © 2016 Get To It Ltd. All rights reserved.
//


import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {

  static var instance = LocationManager()
  var listeners = [LocationListener]()
  var callBack: ((CLLocation) -> ())?
  var nonStopcallBack: ((CLLocation) -> ())?
  var locationUpdate = 101
  var currentId = 0
  let locationManager = CLLocationManager()

  override fileprivate init() {

  }

  func subscribeToUserLocation(_ andDoThisWithIt: @escaping (CLLocation) -> ()) {
    self.setUpLocationListener(andDoThisWithIt)
    print(#function)
    self.listeners.append(LocationListener(id: currentId, callBack: andDoThisWithIt))
  }

  func removeLastListener() {
    self.listeners.removeLast()
  }

  func getUserLocation(_ andDoThisWithIt: @escaping (CLLocation) -> ()) {
    self.setUpLocationListener(andDoThisWithIt)
  }
    
  fileprivate func setUpLocationListener(_ callBack: @escaping (CLLocation) -> ()) {
    self.locationManager.requestWhenInUseAuthorization()
    if CLLocationManager.locationServicesEnabled() {
    
        print(#function)
      locationManager.delegate = self
      locationManager.distanceFilter = 5.0
      locationManager.startUpdatingLocation()
      self.callBack = callBack
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let callBack = callBack {
      callBack(locations[0])
      self.callBack = nil
    }
    if locationUpdate > 35 {
      for listener in listeners {
        if let callBack = listener.callBack {
          callBack(locations[0])
        }
      }
      self.locationUpdate = 0
    }
    self.locationUpdate += 1
  }
}

class LocationListener {
  var callBack: ((CLLocation) -> ())?
  var id: Int
  init(id: Int, callBack: ((CLLocation) -> ())?) {
    self.id = id
    self.callBack = callBack
  }
}
