//
//  DiscoveredEvent.swift
//  Sortons Events
//
//  Created by Brian Henry on 05/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import ObjectMapper

class DiscoveredEvent : Mappable {
    
    var eventId : String!
    var clientId : String!
    var sourcePages: [SourcePage]!
    var name : String!
    var location : String?
    var startTime : NSDate!
    var endTime : NSDate?
    var dateOnly : Bool!
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        eventId <- map["eventId"]
        clientId <- map["clientId"]
        sourcePages <- map["sourcePages"]
        name <- map["name"]
        location <- map["location"]
        startTime  <- (map["startTime"], GAEISO8601DateTransform())
        endTime <- (map["endTime"], GAEISO8601DateTransform())
        dateOnly <- map["dateOnly"]
    }
}