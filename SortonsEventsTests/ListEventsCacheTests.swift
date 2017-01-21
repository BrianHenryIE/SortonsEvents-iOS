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

    var cacheWorker: ListEventsCacheProtocol!
    var testBundle: Bundle!

    override func setUp() {
        super.setUp()
        cacheWorker = ListEventsCacheWorker()

        testBundle = Bundle(for: self.classForCoder)
    }

    func readDataFile() -> String {
        let path = testBundle.path(forResource: "ListEventsCacheTestsData", ofType: "json")!
        guard let discoveredEventsFileData = try? String(contentsOfFile: path) else {
            continueAfterFailure = false
            XCTFail("File error")
            return "" // I don't like this, but it will never reach this code
        }

        return discoveredEventsFileData
    }

    func readDataObjects(fileData: String? = nil) -> [DiscoveredEvent] {

        let discoveredEventsFile = fileData ?? readDataFile()

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

        // Get cache file
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("discoveredevents.json")
        guard let discoveredEventsCachedFile = try? String(contentsOf: fileURL) else {
            XCTFail()
            return
        }

        // Verify the saved file
        let parsedNewFile = try? Mapper<DiscoveredEvent>().mapArray(JSONString: discoveredEventsCachedFile)

        XCTAssertNotNil(parsedNewFile)
    }

    func testWriteNil() {

        let nilEvents: [DiscoveredEvent]? = nil

        cacheWorker.save(nilEvents)

        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("discoveredevents.json")
        let fileFromCache = try? String(contentsOf: fileURL)

        XCTAssertNil(fileFromCache)
    }

    func testRead() {
        let discoveredEvents = readDataObjects()

        cacheWorker.save(discoveredEvents)

        guard let eventsFromCache = cacheWorker.fetch() else {
            XCTFail()
            return
        }

        XCTAssertEqual(discoveredEvents.toJSONString(), eventsFromCache.toJSONString())
    }

    func testReadNoPreviousCache() {
        let previousCache = cacheWorker.fetch()

        XCTAssertNil(previousCache)
    }

    override func tearDown() {

        // Clear the cache
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("discoveredevents.json")
        try? FileManager.default.removeItem(at: fileURL)

        // guard let justWritten = testBundle.path(forResource: "discoveredevents", ofType: "json") 

        super.tearDown()
    }
}
