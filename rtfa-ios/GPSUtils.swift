//
//  GPSUtils.swift
//  OngavaResearchCenter
//
//  Created by Jack Chorley on 29/06/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation
import CoreLocation

class GPSUtils: NSObject, CLLocationManagerDelegate {
    
    public static let shared = GPSUtils()
    
    private var shouldSendCallbacks = false
    
    private let locationManager = CLLocationManager()
    
    private var callback: ((_ loc: CLLocationCoordinate2D, _ alt: Double) -> Void)?
    
    public func authoriseIfNeeded() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func getLocation(callback: @escaping (_ loc: CLLocationCoordinate2D, _ alt: Double) -> Void) {
        self.callback = callback
        shouldSendCallbacks = true
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !shouldSendCallbacks {
            return
        }
        shouldSendCallbacks = false
        locationManager.stopUpdatingLocation()
        callback?(locations.first!.coordinate, locations.first!.altitude)
    }
}
