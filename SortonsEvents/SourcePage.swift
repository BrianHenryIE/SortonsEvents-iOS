//
//  SourcePage.swift
//  SortonsEvents
//
//  Created by Brian Henry on 11/06/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import ObjectMapper

struct SourcePage: SortonsNW, ImmutableMappable {

    static let endpointBase = "https://sortonsevents.appspot.com/_ah/api/clientdata/v1/clientpagedata/"
    static let keyPath = "includedPages"

    let name: String
    let fbPageId: String
    let pageUrl: String
    let street: String?
    let city: String?
    let country: String?
    let latitude: Double?
    let longitude: Double?
    let zip: String?
    let friendlyLocationString: String?

    init(map: Map) throws {
        name = try map.value("name")
        fbPageId = try map.value("fbPageId")
        pageUrl = try map.value("pageUrl")
        street = try? map.value("street")
        city = try? map.value("city")
        country = try? map.value("country")
        latitude = try? map.value("latitude")
        longitude = try? map.value("longitude")
        zip = try? map.value("zip")
        friendlyLocationString = try? map.value("friendlyLocationString")
    }

    func mapping(map: Map) {
        name >>> map["name"]
        fbPageId >>> map["fbPageId"]
        pageUrl >>> map["pageUrl"]
        street >>> map["street"]
        city >>> map["city"]
        country >>> map["country"]
        latitude >>> map["latitude"]
        longitude >>> map["longitude"]
        zip >>> map["zip"]
        friendlyLocationString >>> map["friendlyLocationString"]
    }
}
