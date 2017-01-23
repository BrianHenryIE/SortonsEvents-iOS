//
//  DirectoryCacheWorkerTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 23/05/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest

class DirectoryCacheTests: XCTestCase {

    let cacheWorker = DirectoryCacheWorker()

    func testCilentPageDataCacheWorker() throws {

        // Clear the cache
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("fomo.json")
        try? FileManager.default.removeItem(at: fileURL)

        let clientPageDataFromFile = readJsonFile(filename: "ClientPageDataTcd")

        // Save using eventsCacheWorker
        cacheWorker.save(clientPageDataFromFile)

        // Get file from cache
        let clientPageData = cacheWorker.fetch()

        // Verify the saved file
        XCTAssertEqual(clientPageDataFromFile, clientPageData)

        // Clean up
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            // ...
        }

    }

}
