//
//  EventDetailViewController.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 31/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import UIKit
import RealmSwift

class EventDetailViewController: UIViewController {
    
    @IBOutlet private var paramedicButton: UIButton!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var queueTimesLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var attendingButton: ActionButton!
    
    var event: Event!
    
    var waitTimes: [RegionWaitTime] = []
    
    private var attendingEvent: AttendingEvent? {
        let realm = try! Realm()
        return realm.object(ofType: AttendingEvent.self, forPrimaryKey: event.id)
    }
    
    var isAttending: Bool {
        return attendingEvent != nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    enum CellIdentifier: String {
        case `default` = "defaultCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load existing wait times
        let realm = try! Realm()
        self.waitTimes = Array(realm.objects(RegionWaitTime.self)).filter({ wt -> Bool in
            return wt.region.getEventId() == event.id
        })
        
        // Load the regions & wait times
        RegionService.getRegions(event: event.id) { _,_ in
            RegionWaitTimeService.getWaitTimes(event: self.event, completion: { waitTimes in
                self.waitTimes = waitTimes
                self.tableView.reloadData()
            })
        }
        
        // Register the cells
        tableView.register(UINib(nibName: "EventDetailQueueTimeTableViewCell", bundle: nil), forCellReuseIdentifier: CellIdentifier.default.rawValue)
        
        // If the event is live, show the queue times
        let todayDate = Date()
        if event.startDate < todayDate && event.endDate > todayDate {
            queueTimesLabel.isHidden = false
            tableView.isHidden = false
            paramedicButton.isHidden = false
        } else {
//            queueTimesLabel.isHidden = true
//            tableView.isHidden = true
//            paramedicButton.isHidden = true
        }

        self.imageView.clipsToBounds = true
        
        event.getImage { [weak self] image in
            self?.imageView.image = image
        }
        
        titleLabel.text = event.name
        locationLabel.text = event.location
        
        updateAttendingButton()
    }
    
    @IBAction func paramedicButtonPressed(_ sender: Any) {
        let realm = try! Realm()
        let lastLocations = realm.objects(VisitedRegion.self).filter({ region -> Bool in
            return region.region.getEventId() == self.event.id
        }).sorted { (r1, r2) -> Bool in
            return r1.created! > r2.created!
        }
        
        
        GPSUtils.shared.authoriseIfNeeded()
        GPSUtils.shared.getLocation { (location, altitude) in
            let alert = UIAlertController(title: "Request Paramedic", message: "Type a message, and we will send a paramedic to your location", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { action in
                EmergencyService.sendEmergencyRequest(regions: lastLocations, event: self.event, loc: location, desc: alert.textFields?[0].text ?? "")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    func updateAttendingButton() {
        let title = isAttending ? "I'm Not Attending" : "I'm Attending"
        UIView.performWithoutAnimation {
            attendingButton.setTitle(title, for: .normal)
        }
    }
    
    @IBAction func moreInformationButtonPressed(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegionBreakdownViewController") as! RegionBreakdownViewController
        viewController.event = event
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func attendingButtonPressed() {
        let realm = try! Realm()
        
        if isAttending {
            try! realm.write {
                realm.delete(attendingEvent!)
            }
        } else {
            let attendingEvent = AttendingEvent(event: event)
            try! realm.write {
                realm.add(attendingEvent)
            }
        }
        updateAttendingButton()
    }
}

extension EventDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension EventDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waitTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let waitTime = waitTimes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.default.rawValue, for: indexPath) as! EventDetailQueueTimeTableViewCell
        cell.titleLabel.text = waitTime.region.getName()
        if waitTime.waitTime < 60 {
            cell.timeLabel.text = "\(Int(round(waitTime.waitTime))) seconds"
        } else {
            cell.timeLabel.text = "\(Int(round(waitTime.waitTime / 60))) minutes"
        }
        return cell
    }
}
