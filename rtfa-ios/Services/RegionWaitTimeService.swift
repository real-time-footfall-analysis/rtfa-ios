//
//  LocationWaitTimeService.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 01/11/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class RegionWaitTimeService {
    static func getWaitTimes(event: Event, completion:@escaping ([RegionWaitTime]) -> Void) {
        Alamofire.request("\(apiURL)/events/\(event.id)/tasks/3", method: .get).responseJSON { response in
            switch response.result {
            case .success:
                guard let data = response.data, let json = try! JSON(data: data)["result"].array else {
                    completion([])
                    return
                }
                var waitTimes: [RegionWaitTime] = []
                for item in json {
                    guard let waitTime = RegionWaitTime(json: item) else { continue }
                    waitTimes.append(waitTime)
                }

                let realm = try! Realm()
                try! realm.write {
                    realm.add(waitTimes, update: true)
                }
                completion(waitTimes)
                print("Got queue times - \(json)")
            case .failure(let error):
                print("Failed to get region wait times - \(error.localizedDescription)")
                completion([])
            }
        }
    }
}
