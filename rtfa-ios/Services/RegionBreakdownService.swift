//
//  RegionBreakdownService.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 28/11/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class RegionBreakdownService {
    
    static func getBreakdownGraphs(event: Event, completion:@escaping ([String: JSON]?) -> Void) {
        Alamofire.request("\(apiURL)/events/\(event.id)/tasks/5", method: .get).responseJSON { response in
            switch response.result {
            case .success:
                guard let data = response.data, let json = try! JSON(data: data).dictionary else {
                    completion(nil)
                    return
                }
                completion(json["result"]?.dictionary)
            case .failure(let error):
                print("Failed to get breakdown - \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
