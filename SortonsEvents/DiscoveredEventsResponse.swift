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
// AlamofireObjectMapper addresses using keypath but gotta check if immutable works
final class DiscoveredEventsResponse: ImmutableMappable {

    var data: [DiscoveredEvent]?
    init(map: Map) throws {
        data = try? map.value("data")
    }
}
