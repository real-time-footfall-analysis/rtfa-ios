//
//  File.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 31/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import UIKit

class ActionButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 4
    }
}
