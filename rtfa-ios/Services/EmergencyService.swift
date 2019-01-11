//
//  EmergencyService.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 15/11/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

class EmergencyService {
    static func sendEmergencyRequest(regions: [VisitedRegion], event: Event, loc: CLLocationCoordinate2D?, desc: String) {
        guard let userID = UIDevice.current.identifierForVendor?.uuidString else { return }
        var params: Parameters = ["uuid": userID,
                                  "description": desc,
                                  "regionIds": regions.map({ $0.region.getRegionId() }),
                                  "eventId": event.id,
                                  "dealtWith": false,
                                  "occurredAt": Int(Date().timeIntervalSince1970)]
        if let loc = loc {
            params["position"] = ["lat": loc.latitude, "lng": loc.longitude]
        }
        
        Alamofire.request("\(apiURL)/emergency-update", method: .post, parameters: params, encoding: JSONEncoding.default)
    }
}
