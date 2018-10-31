//
//  LocationManager.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 15/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    private var beacons: [Beacon] = []
    private var locations: [Location] = []
    private var regions: [Int: Region] = [:]
    
    private let beaconManager = ESTBeaconManager()
    private let locationManager = CLLocationManager()
    
    init(beacons: [Beacon], locations: [Location]) {
        super.init()
        self.beacons = beacons
        self.locations = locations
    }
    
    func startMonitoring() {
        restartMonitoring(beacons: beacons, locations: locations)
    }
    
    // Stops current monitoring and restarts with the new parameters
    func restartMonitoring(beacons: [Beacon], locations: [Location]) {
        beaconManager.stopMonitoringForAllRegions()
        locationManager.stopMonitoringVisits()
        
        self.regions = [:]
        self.beacons = beacons
        self.locations = locations
        
        startMonitoringBeacons()
        startTrackingLocationChanges()
    }
    
    func addRegionsToMonitor(beacons: [Beacon], locations: [Location]) {
        restartMonitoring(beacons: self.beacons + beacons, locations: self.locations + locations)
    }
    
    private func startMonitoringBeacons() {
        beaconManager.delegate = self
        beaconManager.requestAlwaysAuthorization()
        
        for beacon in beacons {
            let beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: beacon.uuid)!,
                                              major: CLBeaconMajorValue(beacon.major),
                                              minor: CLBeaconMinorValue(beacon.minor),
                                              identifier: "\(beacon.id)")
            regions[beacon.id] = beacon
            beaconManager.startMonitoring(for: beaconRegion)
        }
    }
    
    private func startTrackingLocationChanges() {
        locationManager.delegate = self
        if !locationManager.allowsBackgroundLocationUpdates {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.allowsBackgroundLocationUpdates = true
        
        for location in locations {
            let locationRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: location.lat, longitude: location.long),
                                                  radius: location.radius,
                                                  identifier: "\(location.id)")
            
            regions[location.id] = location
            // TODO: Implement this myself? Notifications can take 3-5 mins
            locationManager.startMonitoring(for: locationRegion)
        }
    }
}

// MARK: - ESTBeaconManagerDelegate
extension LocationManager: ESTBeaconManagerDelegate {
//    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
//        guard let eventRegion = regions[region.identifier] else { return }
//        RegionService.sendRegionUpdate(region: eventRegion, isEntering: true)
//    }
//
//    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
//        guard let eventRegion = regions[region.identifier] else { return }
//        RegionService.sendRegionUpdate(region: eventRegion, isEntering: false)
//    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let index = Int(region.identifier), let eventRegion = regions[index] else { return }
        RegionService.sendRegionUpdate(region: eventRegion, isEntering: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard let index = Int(region.identifier), let eventRegion = regions[index] else { return }
        RegionService.sendRegionUpdate(region: eventRegion, isEntering: false)
    }
}
