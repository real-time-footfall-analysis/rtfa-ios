//
//  Event.swift
//  rtfa-ios
//
//  Created by Jack Chorley on 19/10/2018.
//  Copyright © 2018 Jack Chorley. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Event: Unmarshallable {
    let id: Int
    let name: String
    let location: String
    let startDate: Date
    let endDate: Date
    let eventType: EventType
    let coverPhotoURL: String
    
    var image: UIImage? = nil
    
    func getImage(callback:@escaping(_ image: UIImage?) -> Void) {
        
        if image != nil {
            callback(image)
        }
        
        URLSession.shared.dataTask(with: URL(string: self.coverPhotoURL)!) { data, response, error in
            DispatchQueue.main.async {
                if data == nil {
                    callback(nil)
                } else {
                    let downloadedImage = UIImage(data: data!)
                    if downloadedImage == nil {
                        callback(nil)
                    }
                    self.image = downloadedImage
                    callback(downloadedImage)
                }
            }
        }.resume()
    }
    
    enum EventType: String {
        case indoor = "indoor"
        case outdoor = "outdoor"
    }
    
    required init?(json: JSON) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        guard let id = json["eventID"].int,
            let name = json["name"].string,
            let location = json["location"].string,
            let startDateString = json["startDate"].string,
            let startDate = dateFormatter.date(from: startDateString),
            let endDateString = json["endDate"].string,
            let endDate = dateFormatter.date(from: endDateString),
            let eventType = EventType(rawValue: json["indoorOutdoor"].string ?? ""),
            let coverPhotoURL = json["coverPhotoUrl"].string
        else { return nil }
        
        self.id = id
        self.name = name
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.eventType = eventType
        self.coverPhotoURL = coverPhotoURL
    }
}
