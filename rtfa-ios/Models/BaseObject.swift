//
//  BaseObject.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 31/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation
import RealmSwift

class BaseObject: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var created: Date? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
