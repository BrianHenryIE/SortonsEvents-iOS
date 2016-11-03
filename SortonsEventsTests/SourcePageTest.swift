//
//  SourcePageTest.swift
//  SortonsEvents
//
//  Created by Brian Henry on 11/06/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

@testable import SortonsEvents
import XCTest
import ObjectMapper

class SourcePageTest: XCTestCase {

    func testTcdAsianJsonParsing() throws {
        
        // Read in the file
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: "SourcePageTcdAsian", ofType: "json")!
        
        let content = try String(contentsOfFile: path)
      
        // Use objectmapper
        let tcdAsian: SourcePage = Mapper<SourcePage>().map(JSONString: content)!
            
        //"id": "884332671653875691002424327686",
        //"about": "The Trinity Centre Asian Studies is a teaching and research centre which offers Chinese, Korean and Japanese Studies as well as pan-Asian area studies.",
        XCTAssertEqual(tcdAsian.name, "Trinity Centre for Asian Studies")
        XCTAssertEqual(tcdAsian.fbPageId, "691002424327686")
        //"phone": "018961560",
    
        XCTAssertEqual(tcdAsian.pageUrl, "https://www.facebook.com/TCD.Asian")
        XCTAssertEqual(tcdAsian.street, "")
        XCTAssertEqual(tcdAsian.city, "Dublin")
        XCTAssertEqual(tcdAsian.country, "Ireland")
        XCTAssertEqualWithAccuracy(tcdAsian.latitude!, 53.34306046, accuracy: 10)
        XCTAssertEqualWithAccuracy(tcdAsian.longitude!, -6.25663396, accuracy: 10)
        XCTAssertEqual(tcdAsian.zip, "D2")
        //"state": "",
        //"uid": "691002424327686",
        // "title", "Trinity Centre for Asian Studies"
        // "subTitle": "Dublin, D2, Ireland",
        XCTAssertEqual(tcdAsian.friendlyLocationString, "Dublin, D2, Ireland")
        //"searchableString": "Trinity Centre for Asian Studies Dublin Ireland Trinity Centre for Asian Studies  ",
        //"class": "ie.sortons.events.shared.SourcePage"
    }
    
}
