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

class RegionService {
    static func sendRegionUpdate(region: Region, isEntering: Bool) {
        guard let userID = UIDevice.current.identifierForVendor?.uuidString else { return }
        let params: Parameters = ["uuid": userID,
                                  "eventId": region.event,
                                  "regionId": region.id,
                                  "entering": isEntering,
                                  "occurredAt": Int(Date().timeIntervalSince1970)]
        
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
                
                completion(beacons, locations)
            case .failure(let error):
                print("Failed to get regions - \(error.localizedDescription)")
                completion([], [])
            }
        }
    }
}