//
//  DiscoveredEventsResponseTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 30/06/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import XCTest
import ObjectMapper

class DiscoveredEventsResponseTests: XCTestCase {

    func testExample() throws {
        
        // Read in the file
        let bundle = NSBundle(forClass: self.classForCoder)
        let path = bundle.pathForResource("DiscoveredEventsResponseNUIG30June16", ofType: "json")!
                
        let content = try String(contentsOfFile: path)
        
        // Use objectmapper
        let nuigJun16 : DiscoveredEventsResponse = Mapper<DiscoveredEventsResponse>().map(content)!
        
        XCTAssertEqual(nuigJun16.data.count, 9)
    }
}
