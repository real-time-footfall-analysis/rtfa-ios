//
//  EventTitleTableViewCell.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 31/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import UIKit

class EventTitleTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
