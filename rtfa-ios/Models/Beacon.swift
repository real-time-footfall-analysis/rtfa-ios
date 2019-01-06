//
//  Beacon.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 17/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

final class Beacon: BaseObject {
    @objc dynamic private var eventId: Int = 0
    var event: Event? {
        let realm = try! Realm()
        return realm.object(ofType: Event.self, forPrimaryKey: eventId)
    }
    @objc dynamic var minor: Int = 0
    @objc dynamic var major: Int = 0
    @objc dynamic var uuid: String = ""
    @objc dynamic var isQueue: Bool = false
    @objc dynamic var name: String = ""
}

extension Beacon: Unmarshallable {
    convenience init?(json: JSON) {
        self.init()
        guard let id = json["regionID"].int,
            let eventId = json["eventID"].int,
            let minor = json["minor"].int,
            let major = json["major"].int,
            let uuid = json["uuid"].string,
            let isQueue = json["isQueue"].bool,
            let name = json["name"].string
            else { return nil }
        
        self.id = id
        self.created = Date()
        self.eventId = eventId
        self.minor = minor
        self.major = major
        self.uuid = uuid
        self.isQueue = isQueue
        self.name = name
    }
}

extension Beacon: Region {
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
