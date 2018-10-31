//
//  Beacon.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 17/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Beacon: BaseObject {
    @objc dynamic private var eventId: Int = 0
    @objc dynamic var minor: Int = 0
    @objc dynamic var major: Int = 0
    @objc dynamic var uuid: String = ""
}

extension Beacon: Unmarshallable {
    convenience init?(json: JSON) {
        self.init()
        guard let id = json["regionID"].int,
            let eventId = json["eventID"].int,
            let minor = json["minor"].int,
            let major = json["major"].int,
            let uuid = json["uuid"].string else { return nil }
        
        self.id = id
        self.created = Date()
        self.eventId = eventId
        self.minor = minor
        self.major = major
        self.uuid = uuid
    }
}

extension Beacon: Region {
    func getEventId() -> Int {
        return self.eventId
    }
    
    func getRegionId() -> Int {
        return self.id
    }
}
