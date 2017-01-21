//
//  DiscoveredEvent.swift
//  Sortons Events
//
//  Created by Brian Henry on 05/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import ObjectMapper

struct DiscoveredEvent: ImmutableMappable {

    var eventId: String
    var clientId: String
    var sourcePages: [SourcePage]
    var name: String
    var location: String?
    var startTime: Date
    var endTime: Date? //TODO
    var dateOnly: Bool

    init(map: Map) throws {
        eventId = try map.value("eventId")
        clientId = try map.value("clientId")
        sourcePages = try map.value("sourcePages")
        name = try map.value("name")
        location = try? map.value("location")
        startTime = try map.value("startTime", using: GAEISO8601DateTransform())
        endTime = try? map.value("endTime", using: GAEISO8601DateTransform())
        dateOnly = try map.value("dateOnly")
    }

    func mapping(map: Map) {
        eventId >>> map["eventId"]
        clientId >>> map["clientId"]
        sourcePages >>> map["sourcePages"]
        name >>> map["name"]
        location >>> map["location"]
        startTime >>> (map["startTime"], GAEISO8601DateTransform())
        endTime >>> (map["endTime"], GAEISO8601DateTransform())
        dateOnly >>> map["dateOnly"]
    }
}
