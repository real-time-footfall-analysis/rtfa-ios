//
//  VisitedRegion.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 15/11/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation

class VisitedRegion: BaseObject {
    @objc private dynamic var beacon: Beacon?
    @objc private dynamic var location: Location?
    
    var region: Region {
        if let beacon = beacon {
            return beacon
        }
        return location!
    }
    
    convenience init(beacon: Beacon) {
        self.init()
        self.id = UUID().uuidString.hashValue
        self.created = Date()
        self.beacon = beacon
    }
    
    convenience init(location: Location) {
        self.init()
        self.id = UUID().uuidString.hashValue
        self.created = Date()
        self.location = location
    }
}
