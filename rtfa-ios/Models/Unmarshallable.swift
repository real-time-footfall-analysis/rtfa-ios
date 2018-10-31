//
//  Unmarshallable.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 18/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Unmarshallable {
    init?(json: JSON)
}
