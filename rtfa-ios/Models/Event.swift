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

final class Event: BaseObject {
    @objc dynamic var name: String = ""
    @objc dynamic var location: String = ""
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date()
    @objc dynamic private var rawEventType: String = ""
    var eventType: EventType {
        return EventType(rawValue: rawEventType) ?? .outdoor
    }
    
    @objc dynamic var coverPhotoURL: String = ""
    
    enum EventType: String {
        case indoor = "indoor"
        case outdoor = "outdoor"
    }
    
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
}

extension Event: Unmarshallable {
    convenience init?(json: JSON) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        guard let id = json["eventID"].int,
            let name = json["name"].string,
            let location = json["location"].string,
            let startDateString = json["startDate"].string,
            let startDate = dateFormatter.date(from: startDateString),
            let endDateString = json["endDate"].string,
            let endDate = dateFormatter.date(from: endDateString),
            let rawEventType = json["indoorOutdoor"].string,
            let coverPhotoURL = json["coverPhotoUrl"].string
            else { return nil }
        
        self.init()
        self.id = id
        self.created = Date()
        self.name = name
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.rawEventType = rawEventType
        self.coverPhotoURL = coverPhotoURL
    }
}
