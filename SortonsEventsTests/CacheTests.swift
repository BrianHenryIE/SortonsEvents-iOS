//
//  ListEventsCacheTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 22/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest
import ObjectMapper

class ListEventsCacheTests: XCTestCase {

    var cacheWorker: CacheProtocol!
    var testBundle: Bundle!
    let fileManager = FileManager.default
    let fileURL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                                           .userDomainMask, true).first!)
        .appendingPathComponent("DiscoveredEvent.json")

    override func setUp() {
        super.setUp()
        cacheWorker = CacheWorker<DiscoveredEvent>()

        testBundle = Bundle(for: self.classForCoder)
    }

    func readDataObjects(fileData: String? = nil) -> [DiscoveredEvent] {

        let discoveredEventsFile = fileData
            ?? readJsonFile(filename: "ListEventsCacheTestsData")

        guard let discoveredEvents = try? Mapper<DiscoveredEvent>().mapArray(JSONString: discoveredEventsFile) else {
            continueAfterFailure = false
            XCTFail("File parse error")
            return [DiscoveredEvent]()
        }

        return discoveredEvents
    }

    func testWrite() throws {

        let dataObjects = readDataObjects()

        cacheWorker.save(dataObjects)

        guard let fileFromCache = try? String(contentsOf: fileURL) else {
            XCTFail()
            return
        }

        // Verify the saved file
        let parsedNewFile = try? Mapper<DiscoveredEvent>().mapArray(JSONString: fileFromCache)

        XCTAssertNotNil(parsedNewFile)
    }

    func testWriteNil() {

        let nilEvents: [DiscoveredEvent]? = nil

        cacheWorker.save(nilEvents)

        let fileFromCache = try? String(contentsOf: fileURL)

        XCTAssertNil(fileFromCache)
    }

    func testFetch() {
        let discoveredEvents = readDataObjects()

        cacheWorker.save(discoveredEvents)

        guard let eventsFromCache: [DiscoveredEvent] = cacheWorker.fetch() else {
            XCTFail()
            return
        }

        XCTAssertEqual(discoveredEvents.toJSONString(), eventsFromCache.toJSONString())
    }

    func testFetchNoPreviousCache() {

        let cacheFileExistsPath = fileManager.fileExists(atPath: fileURL.path)
        XCTAssertFalse(cacheFileExistsPath)

        let cacheFileExistsAbs = fileManager.fileExists(atPath: fileURL.absoluteString)
        XCTAssertFalse(cacheFileExistsAbs)

        let previousCache: [DiscoveredEvent]? = cacheWorker.fetch()

        XCTAssertNil(previousCache)
    }

    func testMixedMappableArrayBehaviour() {
        // test with data array containing
        // some good objects and some incomplete
        // Test with an array of mixed ImmutableMappable -
        // might write but not read!
    }

    override func tearDown() {

        // Clear the cache
        try? FileManager.default.removeItem(at: fileURL)

        super.tearDown()
    }

}
