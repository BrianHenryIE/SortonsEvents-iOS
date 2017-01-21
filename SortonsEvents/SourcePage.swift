//
//  SourcePage.swift
//  SortonsEvents
//
//  Created by Brian Henry on 11/06/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import ObjectMapper

// should be struct!? (...but ObjectMapper) //TODO
class SourcePage: Mappable {

    var name: String!
    var fbPageId: String!
    var pageUrl: String!
    var street: String?
    var city: String?
    var country: String?
    var latitude: Double?
    var longitude: Double?
    var zip: String?
    var friendlyLocationString: String?

    required init?(map _: Map) {

    }

    func mapping(map: Map) {
        name <- map["name"]
        fbPageId <- map["fbPageId"]
        pageUrl <- map["pageUrl"]
        street <- map["street"]
        city  <- map["city"]
        country <- map["country"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        zip <- map["zip"]
        friendlyLocationString <- map["friendlyLocationString"]
    }
}
