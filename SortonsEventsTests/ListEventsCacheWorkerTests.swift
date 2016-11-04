//
//  ListEventsCacheWorkerTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 22/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import XCTest
@testable import SortonsEvents

class ListEventsCacheWorkerTests: XCTestCase {
    
    let listEventsCacheWorker = DirectoryCacheWorker()
    
    func testListEventsCacheWorker() throws {
        
        // Clear the cache
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("discoveredevents.json")
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            // ...
        }
        
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: "DiscoveredEventsResponseNUIG30June16", ofType: "json")!
        let discoveredEventsFromFile = try String(contentsOfFile: path)
        
        // Save using eventsCacheWorker
        listEventsCacheWorker.save(discoveredEventsFromFile)
        
        // Get file from cache
        let discoveredEvents = listEventsCacheWorker.fetch()
        
        // Verify the saved file
        XCTAssertEqual(discoveredEventsFromFile, discoveredEvents)
        
        // Clean up
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            // ...
        }
    }
}
