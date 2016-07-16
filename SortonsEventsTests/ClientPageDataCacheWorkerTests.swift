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
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("fomo.json")
        do {
            try NSFileManager.defaultManager().removeItemAtURL(fileURL)
        } catch {
            // ...
        }
        
        // Read test ClientPageData from file
        let bundle = NSBundle(forClass: self.classForCoder)
        let path = bundle.pathForResource("ClientPageDataUcdEvents", ofType: "json")!
        let clientPageDataFromFile = try String(contentsOfFile: path)
        
        // Save using eventsCacheWorker
        clientPageDataCacheWorker.save(clientPageDataFromFile)
        
        let expectation = expectationWithDescription("clientPageDataCacheWorker.fetch()")
        
        // Get file from cache
        clientPageDataCacheWorker.fetch() { (clientPageData: String) in
        
            // Verify the saved file
            XCTAssertEqual(clientPageDataFromFile, clientPageData)

            expectation.fulfill()
            
        }
        
        waitForExpectationsWithTimeout(5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        // Clean up
        do {
            try NSFileManager.defaultManager().removeItemAtURL(fileURL)
        } catch {
            // ...
        }

        
    }
    
}
