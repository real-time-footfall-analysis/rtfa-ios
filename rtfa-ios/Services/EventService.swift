//
//  BeaconService.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 15/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class EventService {
    
    static func getEvents(completion:@escaping ([Event]) -> Void) {
        Alamofire.request("\(apiURL)/events", method: .get).responseJSON { response in
            switch response.result {
            case .success:
                guard let data = response.data, let json = try! JSON(data: data).array else {
                    completion([])
                    return
                }
                
                var events: [Event] = []
                for item in json {
                    guard let event = Event(json: item) else { continue }
                    events.append(event)
                }
                
                let realm = try! Realm()
                try! realm.write {
                    realm.add(events, update: true)
                }
                completion(events)
            case .failure(let error):
                print("Failed to get events - \(error.localizedDescription)")
                completion([])
            }
        }
    }
}
