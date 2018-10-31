//
//  Beacon.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 17/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation
import SwiftyJSON

// TODO: Change to persistant class when UI is built up
class Beacon: Region, Unmarshallable {
    let minor: Int
    let major: Int
    let uuid: String
    
    required init?(json: JSON) {
        guard let id = json["regionID"].int,
            let eventId = json["eventID"].int,
            let minor = json["minor"].int,
            let major = json["major"].int,
            let uuid = json["uuid"].string else { return nil }
        
        self.minor = minor
        self.major = major
        self.uuid = uuid
        super.init(id: id, event: eventId)
    }
}
