//
//  ClientPageData.swift
//  SortonsEvents
//
//  Created by Brian Henry on 30/06/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import ObjectMapper

class ClientPageData: Mappable {

    var clientPageId: String!
    var clientPage: SourcePage!
    var includedPages: [SourcePage]!

    required init?(map _: Map) {

    }

    // Mappable
    func mapping(map: Map) {
        clientPageId <- map["clientPageId"]
        clientPage <- map["clientPage"]
        includedPages <- map["includedPages"]
    }
}
