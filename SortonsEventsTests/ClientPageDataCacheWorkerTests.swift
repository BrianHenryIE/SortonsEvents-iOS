//
//  EventsCacheWorkerTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 23/05/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import XCTest

class ClientPageDataCacheWorkerTests: XCTestCase {
    
    let clientPageDataCacheWorker = ClientPageDataCacheWorker()
    
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
        let path = bundle.path(forResource: "ClientPageDataUcdEvents", ofType: "json")!
        let clientPageDataFromFile = try String(contentsOfFile: path)
        
        // Save using eventsCacheWorker
        clientPageDataCacheWorker.save(clientPageDataFromFile)
        
        let expectation = self.expectation(description: "clientPageDataCacheWorker.fetch()")
        
        // Get file from cache
        clientPageDataCacheWorker.fetch() { (clientPageData: String) in
        
            // Verify the saved file
            XCTAssertEqual(clientPageDataFromFile, clientPageData)

            expectation.fulfill()
            
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        // Clean up
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            // ...
        }

        
    }
    
}
