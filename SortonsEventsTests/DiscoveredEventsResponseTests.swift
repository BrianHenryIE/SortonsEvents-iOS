//
//  DiscoveredEventsResponseTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 30/06/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

@testable import SortonsEvents
import XCTest
import ObjectMapper

class DiscoveredEventsResponseTests: XCTestCase {

    func testParseDiscoveredEventsJson() throws {
        
        // Read in the file
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: "DiscoveredEventsResponseNUIG30June16", ofType: "json")!
                
        let content = try String(contentsOfFile: path)
        
        // Use objectmapper
        let nuigJun16: DiscoveredEventsResponse = Mapper<DiscoveredEventsResponse>().map(JSONString: content)!
        
        XCTAssertEqual(nuigJun16.data.count, 9)
    }
}
