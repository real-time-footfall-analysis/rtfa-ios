//
//  LocationWaitTime.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 01/11/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

final class RegionWaitTime: BaseObject {
    @objc dynamic var waitTime: Double = 0
    
    var region: Region {
        let realm = try! Realm()
        guard let beacon = realm.object(ofType: Beacon.self, forPrimaryKey: id) else {
            return realm.object(ofType: Location.self, forPrimaryKey: id)!
        }
        return beacon
    }
}

extension RegionWaitTime: Unmarshallable {
    convenience init?(json: JSON) {
        guard let id = json["id"].int,
            let waitTime = json["waitTime"].double else { return nil }
        self.init()
        self.id = id
        self.waitTime = waitTime
    }
}
