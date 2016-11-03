//
//  DirectoryCacheWorkerTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 23/05/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import XCTest
@testable import SortonsEvents

class DirectoryCacheWorkerTests: XCTestCase {
    
    let directoryCacheWorker = DirectoryCacheWorker()
    
    func testCilentPageDataCacheWorker() throws {
       
        // Clear the cache
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("fomo.json")
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            // ...
        }
        
        // Read test ClientPageData from file
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: "ClientPageDataTcd", ofType: "json")!
        let clientPageDataFromFile = try String(contentsOfFile: path)
        
        // Save using eventsCacheWorker
        directoryCacheWorker.save(clientPageDataFromFile)
        
        // Get file from cache
        let clientPageData = directoryCacheWorker.fetch()
            
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
