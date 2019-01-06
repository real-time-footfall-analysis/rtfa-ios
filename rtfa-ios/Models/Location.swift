//
//  Locatio.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 17/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

final class Location: BaseObject {
    @objc dynamic private var eventId: Int = 0
    var event: Event? {
        let realm = try! Realm()
        return realm.object(ofType: Event.self, forPrimaryKey: eventId)
    }
    @objc dynamic var lat: Double = 0
    @objc dynamic var long: Double = 0
    @objc dynamic var radius: Double = 0
    @objc dynamic var isQueue: Bool = false
    @objc dynamic var name: String = ""
    
}

extension Location: Unmarshallable {
    convenience init?(json: JSON) {
        self.init()
        guard let id = json["regionID"].int,
            let eventId = json["eventID"].int,
            let lat = json["lat"].double,
            let long = json["lng"].double,
            let rad = json["radius"].double,
            let isQueue = json["isQueue"].bool,
            let name = json["name"].string
            else { return nil }
        
        self.id = id
        self.created = Date()
        self.eventId = eventId
        self.lat = lat
        self.long = long
        self.radius = rad
        self.isQueue = isQueue
        self.name = name
    }
}

extension Location: Region {
    func getEventId() -> Int {
        return self.eventId
    }
    
    func getRegionId() -> Int {
        return self.id
    }
    
    func getName() -> String {
        return self.name
    }
}
