//
//  ViewController.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 14/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import UIKit
import RealmSwift

class EventsViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    enum CellIdentifier: String {
        case `default` = "defaultCell"
        case title = "title"
    }
    
    private var events: [Event] = []
    private var attendingEvents: [AttendingEvent] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the cells
        tableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: CellIdentifier.default.rawValue)
        tableView.register(UINib(nibName: "EventTitleTableViewCell", bundle: nil), forCellReuseIdentifier: CellIdentifier.title.rawValue)
        
        // Remove the trailing cells
        tableView.tableFooterView = UIView()
        
        // Get the events
        EventService.getEvents { events in
            self.updateEvents()
        }
        
       // Ensure we can always swipe to go back
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateEvents()
    }
    
    func updateEvents() {
        let realm = try! Realm()
        events = Array(realm.objects(Event.self).sorted(by: { $0.startDate < $1.startDate }))
        attendingEvents = Array(realm.objects(AttendingEvent.self).sorted(by: { $0.event!.startDate < $1.event!.startDate }))
        tableView.reloadData()
    }
}

extension EventsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let count = navigationController?.viewControllers.count else { return false }
        return count > 1
    }
}

extension EventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        
        // TODO: Remove this when next view controller is ready
        let realm = try! Realm()
        if indexPath.section == 0 {
            try! realm.write {
                realm.delete(attendingEvents[indexPath.row - 1])
            }
        } else {
            let attendEvent = AttendingEvent(event: events[indexPath.row - 1])
            try! realm.write {
                realm.add(attendEvent)
            }
        }
        
        updateEvents()
    }
}

extension EventsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return attendingEvents.count > 0 ? attendingEvents.count + 1 : 0
        }
        
        return events.count > 0 ? events.count + 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.title.rawValue, for: indexPath) as! EventTitleTableViewCell
            cell.titleLabel.text = indexPath.section == 0 ? "My Events" : "Upcoming Events"
            return cell
        }
        
        let event: Event
        if indexPath.section == 0 {
            event = attendingEvents[indexPath.row - 1].event!
        } else {
            event = events[indexPath.row - 1]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.default.rawValue, for: indexPath) as! EventTableViewCell
        
        event.getImage { image in
            cell.eventImageView.image = image
        }
        
        cell.nameLabel.text = event.name
        cell.locationLabel.text = event.location
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 72
        }
        return self.view.frame.size.width * 0.9
    }
}
