//
//  Locatio.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 17/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Location: BaseObject {
    @objc dynamic private var eventId: Int = 0
    @objc dynamic var lat: Double = 0
    @objc dynamic var long: Double = 0
    @objc dynamic var radius: Double = 0
    
}

extension Location: Unmarshallable {
    convenience init?(json: JSON) {
        self.init()
        guard let id = json["regionID"].int,
            let eventId = json["eventID"].int,
            let lat = json["lat"].double,
            let long = json["lng"].double,
            let rad = json["radius"].double else { return nil }
        
        self.id = id
        self.created = Date()
        self.eventId = eventId
        self.lat = lat
        self.long = long
        self.radius = rad
    }
}

extension Location: Region {
    func getEventId() -> Int {
        return self.eventId
    }
    
    func getRegionId() -> Int {
        return self.id
    }
}
