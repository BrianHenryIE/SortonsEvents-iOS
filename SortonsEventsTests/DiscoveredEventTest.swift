//
//  DiscoveredEventTest.swift
//  SortonsEvents
//
//  Created by Brian Henry on 11/06/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import XCTest
import ObjectMapper
// @testable import SortonsEvents

class DiscoveredEventTest: XCTestCase {

    
    func testDiscoveredEventParsing() throws {
        
        // Read in the file
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: "DiscoveredEventNIUGBicycleVolunteering", ofType: "json")!
        let content = try String(contentsOfFile: path)
      
        // Use objectmapper
        let nuigCycling : DiscoveredEvent = Mapper<DiscoveredEvent>().map(JSONString: content)!
        
        // Verify
        XCTAssertEqual(nuigCycling.eventId, "918777258231182")
        XCTAssertEqual(nuigCycling.clientId, "1049082365115363")
        XCTAssertEqual(nuigCycling.sourcePages.count, 1)
        XCTAssertEqual(nuigCycling.sourcePages[0].name, "Alive Nuigalway")
        XCTAssertEqual(nuigCycling.name, "Information Evening for Volunteering with Galway's Community Bicycle Workshop")
        XCTAssertEqual(nuigCycling.location, "Block R, Earls Island, University Road, Galway.")

        let calendar = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.year = 2016
        dateComponents.month = 06
        dateComponents.day = 30
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        dateComponents.hour = 18
        dateComponents.minute = 00
        
        // "startTime": "2016-06-30T18:00:00.000Z",
        let startTime = calendar.date(from: dateComponents)
        XCTAssertEqual(nuigCycling.startTime, startTime)
        
        // "endTime": "2016-06-30T19:00:00.000Z",
        dateComponents.hour = 19
        let endTime = calendar.date(from: dateComponents)
        XCTAssertEqual(nuigCycling.endTime, endTime)
        
        XCTAssertEqual(nuigCycling.dateOnly, false)
        
    }
}
