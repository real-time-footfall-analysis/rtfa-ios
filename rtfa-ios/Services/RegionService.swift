//
//  BeaconService.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 15/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift
import PushNotifications

class RegionService {
    static func sendRegionUpdate(region: Region, isEntering: Bool) {
        
        // If we enter a new region, save a log of it for paramedics
        if isEntering {
            if let region = region as? Beacon {
                let visitedRegion = VisitedRegion(beacon: region)
                let realm = try! Realm()
                try! realm.write {
                    realm.add(visitedRegion)
                }
            } else if let region = region as? Location {
                let visitedRegion = VisitedRegion(location: region)
                let realm = try! Realm()
                try! realm.write {
                    realm.add(visitedRegion)
                }
            }
            try? PushNotifications.shared.subscribe(interest: "\(region.getRegionId())")
        } else {
            try? PushNotifications.shared.unsubscribe(interest: "\(region.getRegionId())")
        }
        
        guard let userID = UIDevice.current.identifierForVendor?.uuidString else { return }
        let params: Parameters = ["uuid": userID,
                                  "eventId": region.getEventId(),
                                  "regionId": region.getRegionId(),
                                  "entering": isEntering,
                                  "occurredAt": Int(Date().timeIntervalSince1970 * 1000)]
        
        Alamofire.request("\(apiURL)/update", method: .post, parameters: params, encoding: JSONEncoding.default)
    }
    
    static func getRegions(event: Int, completion:@escaping ([Beacon], [Location]) -> Void) {
        Alamofire.request("\(apiURL)/events/\(event)/regions", method: .get).responseJSON { response in
            switch response.result {
            case .success:
                guard let data = response.data, let json = try! JSON(data: data).array else {
                    completion([], [])
                    return
                }
                
                var beacons: [Beacon] = []
                var locations: [Location] = []
                for item in json {
                    if item["type"] == "beacon" {
                        guard let beacon = Beacon(json: item) else { continue }
                        beacons.append(beacon)
                    } else if item["type"] == "gps" {
                        guard let loc = Location(json: item) else { continue }
                        locations.append(loc)
                    }
                }
                let realm = try! Realm()
                try! realm.write {
                    realm.add(beacons, update: true)
                    realm.add(locations, update: true)
                }
                completion(beacons, locations)
            case .failure(let error):
                print("Failed to get regions - \(error.localizedDescription)")
                completion([], [])
            }
        }
    }
}
