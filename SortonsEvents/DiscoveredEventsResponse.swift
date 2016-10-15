//
//  DiscoveredEventsResponse.swift
//  SortonsEvents
//
//  Created by Brian Henry on 30/06/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

import ObjectMapper

// This whole object is because Google App Engine can't straight return Lists<>
class DiscoveredEventsResponse: Mappable {
    
    var data: [DiscoveredEvent]!
    
    required init?(map _: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        data <- map["data"]
    }
}
