//
//  ListEventsCacheWorker.swift
//  SortonsEvents
//
//  Created by Brian Henry on 12/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import ObjectMapper

protocol ListEventsCacheProtocol {

    func fetch() -> [DiscoveredEvent]?
    func save(_ latestClientPageData: [DiscoveredEvent]?)
}

class ListEventsCacheWorker: ListEventsCacheProtocol {

    private let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("discoveredevents.json")

    func fetch() -> [DiscoveredEvent]? {

        // TODO test data with some good objects and some incomplete
        if let fileFromCache = try? String(contentsOf: fileURL) {
            let eventsFromCache = try? Mapper<DiscoveredEvent>().mapArray(JSONString: fileFromCache)
            return eventsFromCache
        }
        return nil
    }

    func save(_ freshEventsData: [DiscoveredEvent]?) {

        let data = freshEventsData?.toJSONString(prettyPrint: false)

        try? data?.write(to: fileURL, atomically: true, encoding: .utf8)
    }
}
