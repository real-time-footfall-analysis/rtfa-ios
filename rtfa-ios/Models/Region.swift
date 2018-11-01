//
//  Region.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 17/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation
import RealmSwift

//final class Region: BaseObject {
//
//    @objc dynamic var eventId = 1
////    var event: Event {
////        return Event
////    }
//}

protocol Region {
    func getEventId() -> Int
    func getRegionId() -> Int
}
