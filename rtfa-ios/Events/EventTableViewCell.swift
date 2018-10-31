//
//  EventTableViewCell.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 30/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet private var innerView: UIView!
    
    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.innerView.layer.borderWidth = 1
        self.innerView.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1).cgColor
        self.innerView.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
