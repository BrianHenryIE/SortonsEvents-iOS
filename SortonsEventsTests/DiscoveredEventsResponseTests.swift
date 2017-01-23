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

        let content = readJsonFile(filename: "DiscoveredEventsResponseNUIG30June16")

        // Use objectmapper
        guard let nuigJun16 = try? Mapper<DiscoveredEventsResponse>().map(JSONString: content),
            let data = nuigJun16.data else {
            XCTFail("")
            return
        }

        XCTAssertEqual(data.count, 9)

    }
}
