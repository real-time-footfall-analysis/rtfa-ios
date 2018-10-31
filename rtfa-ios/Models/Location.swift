//
//  Locatio.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 17/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation
import SwiftyJSON

class Location: Region, Unmarshallable {
    let lat: Double
    let long: Double
    let radius: Double
    
    required init?(json: JSON) {
        guard let id = json["regionID"].int,
            let eventId = json["eventID"].int,
            let lat = json["lat"].double,
            let long = json["lng"].double,
            let rad = json["radius"].double else { return nil }
        
        self.lat = lat
        self.long = long
        self.radius = rad
        super.init(id: id, event: eventId)
    }
}
