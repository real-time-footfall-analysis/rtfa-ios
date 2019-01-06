//
//  RegionBreakdownTableViewCell.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 28/11/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import UIKit
import Charts

class RegionBreakdownTableViewCell: UITableViewCell {

    @IBOutlet var regionLabel: UILabel!
    @IBOutlet var barChartView: BarChartView!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet private var roundedView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        roundedView.layer.cornerRadius = 8
        
        self.roundedView.layer.borderWidth = 1
        self.roundedView.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1).cgColor
        self.roundedView.layer.cornerRadius = 4
        
//        roundedView.layer.shadowColor = UIColor.black.cgColor
//        roundedView.layer.shadowRadius = 6
//        roundedView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        roundedView.layer.masksToBounds = false
//        roundedView.layer.shadowOpacity = 0.2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
