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

  override private init() {

  }

  func subscribeToUserLocation(andDoThisWithIt: (CLLocation) -> ()) {
    self.setUpLocationListener(andDoThisWithIt)
    self.listeners.append(LocationListener(id: currentId, callBack: andDoThisWithIt))
  }

  func removeLastListener() {
    self.listeners.removeLast()
  }

  func getUserLocation(andDoThisWithIt: (CLLocation) -> ()) {
    self.setUpLocationListener(andDoThisWithIt)
  }
    
  private func setUpLocationListener(callBack: (CLLocation) -> ()) {
    self.locationManager.requestWhenInUseAuthorization()
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation()
      self.callBack = callBack
    }
  }

  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
