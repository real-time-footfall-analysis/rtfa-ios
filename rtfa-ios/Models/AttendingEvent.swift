//
//  AttendingEvent.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 31/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation

final class AttendingEvent: BaseObject {
    @objc dynamic var event: Event?
    
    convenience init(event: Event) {
        self.init()
        self.event = event
    }
}
