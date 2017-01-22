//
//  ClientPageData.swift
//  SortonsEvents
//
//  Created by Brian Henry on 30/06/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import ObjectMapper

struct ClientPageData: ImmutableMappable {

    let clientPageId: String
    let clientPage: SourcePage
    let includedPages: [SourcePage]

    init(map: Map) throws {
        clientPageId = try map.value("clientPageId")
        clientPage = try map.value("clientPage")
        includedPages = try map.value("includedPages")
    }

    func mapping(map: Map) {
        clientPageId >>> map["clientPageId"]
        clientPage >>> map["clientPage"]
        includedPages >>> map["includedPages"]
    }
}
