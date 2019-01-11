//
//  RegionBreakdownViewController.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 28/11/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import UIKit
import Charts
import RealmSwift
import SwiftyJSON
import SwiftDate

class RegionBreakdownViewController: UIViewController {

    var event: Event!
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    
    enum CellIdentifier: String {
        case `default` = "defaultCell"
    }
    
    struct RegionDataPoint {
        let regionName: String
        let regionId: Int
        let points: [Int]
        let ratios: [Double]
    }
    
    private var dataPoints: [RegionDataPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = event.name
        
        tableView.register(UINib(nibName: "RegionBreakdownTableViewCell", bundle: nil), forCellReuseIdentifier: CellIdentifier.default.rawValue)
        
        RegionBreakdownService.getBreakdownGraphs(event: event) { json in
            
            self.dataPoints = []
            guard let json = json else {
                print("Uh oh, no data for this event")
                return
            }
            
            let realm = try! Realm()
            var regions = Array(realm.objects(Beacon.self).filter({ $0.getEventId() == self.event.id }).map({ b -> (String, Int) in return (b.getName(), b.getRegionId()) }))
            regions.append(contentsOf: Array(realm.objects(Location.self).filter({ $0.getEventId() == self.event.id }).map({ l -> (String, Int) in return (l.getName(), l.getRegionId()) })))
            
            for (regionName, regionId) in regions {
                if let countData = json["counts"]?["\(regionId)"].dictionary, let ratioData = json["ratios"]?["\(regionId)"].dictionary {
                    let newDataPoint = RegionDataPoint(regionName: regionName, regionId: regionId, points: self.generateGraphDataForRegion(json: countData), ratios: self.generateGraphRatiosForRegion(json: ratioData))
                    self.dataPoints.append(newDataPoint)
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    private func generateGraphDataForRegion(json: [String: JSON]) -> ([Int]) {
        
        var result: [Int] = []
        // We want data between 6am and midnight in 30 minute increments. This is 37 datapoints
        for i in 0..<37 {
            let seconds = 21600 + i * 1800
            guard let value = json["\(seconds)"]?.int else {
                result.append(0)
                continue
            }
            result.append(value)
        }
        return result
    }
    
    
    private func generateGraphRatiosForRegion(json: [String: JSON]) -> ([Double]) {
        
        var result: [Double] = []
        // We want data between 6am and midnight in 30 minute increments. This is 37 datapoints
        for i in 0..<37 {
            let seconds = 21600 + i * 1800
            guard let value = json["\(seconds)"]?.double else {
                result.append(0)
                continue
            }
            result.append(value)
        }
        return result
    }
    
    func formatBarChart(barChart: BarChartView) {
        formatAxis(axis: barChart.xAxis)
        formatAxis(axis: barChart.leftAxis)
        formatAxis(axis: barChart.rightAxis)
        
        barChart.legend.enabled = false
        barChart.drawBordersEnabled = false
    }
    
    func formatAxis(axis: XAxis) {
//        axis.granularity = 1
        axis.valueFormatter = LabelFormatter()
        axis.drawGridLinesEnabled = false
        axis.labelPosition = .bottom
        axis.drawAxisLineEnabled = false
    }
    
    func formatAxis(axis: YAxis) {
        axis.drawLabelsEnabled = false
        axis.drawGridLinesEnabled = false
        axis.drawAxisLineEnabled = false
    }
}

extension RegionBreakdownViewController: UITableViewDelegate {
    
}

extension RegionBreakdownViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataPoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.default.rawValue, for: indexPath) as! RegionBreakdownTableViewCell
        
        let dataPoint = dataPoints[indexPath.row]
        
        let now = Date()
        let refDate = Date(components: {
            $0.year = now.year
            $0.month = now.month
            $0.day = now.day
            $0.hour = 0
        })!
        
        let offset = now.timeIntervalSince(refDate)
        
        var index = Int((offset - 21600) / 1800)
        if index < 0 || index >= dataPoint.ratios.count {
            index = 0
        }
        
        cell.regionLabel.text = dataPoint.regionName
        cell.descriptionLabel.text = messageForRatio(ratio: dataPoint.ratios[index])
        
        var data: [BarChartDataEntry] = []
        var colors: [NSUIColor] = []
        for (i, point) in dataPoint.points.enumerated() {
            data.append(BarChartDataEntry(x: Double(i), y: Double(point)))
            
            if i == index {
                colors.append(NSUIColor.brandPurple)
            } else {
                colors.append(NSUIColor.brandGrey)
            }
        }
        
        let dataset = BarChartDataSet(values: data, label: nil)
        dataset.colors = colors
        dataset.drawValuesEnabled = false
        
        let barChartData = BarChartData(dataSet: dataset)
        
        cell.barChartView.data = barChartData
        cell.barChartView.isUserInteractionEnabled = false
        
        formatBarChart(barChart: cell.barChartView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 272
    }
    
    private func messageForRatio(ratio: Double) -> String {
        if ratio < 0.3 {
            return "Usually quiet at this time."
        }
        
        if ratio < 0.7 {
            return "A little busy right now."
        }
        
        return "Very crowded - try using alternative facilities."
    }
}

class LabelFormatter: IAxisValueFormatter {
    
    let values = ["6a", "6:30a", "7a", "7:30a", "8a", "8:30a", "9a", "9:30a", "10a", "10:30a", "11a", "11:30a", "12", "12:30p", "1p", "1:30p", "2p", "2:30p", "3p", "3:30p", "4p", "4:30p", "5p", "5:30p", "6p", "6:30p", "7p", "7:30p", "8p", "8:30p", "9p", "9:30p", "10p", "10:30p", "11p", "11:30p", "12"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return values[Int(value)]
    }
    
    
}
