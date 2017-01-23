//
//  ClientPageDataTest.swift
//  SortonsEvents
//
//  Created by Brian Henry on 30/06/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest
import ObjectMapper

class ClientPageDataTest: XCTestCase {

    func testClientPageDataParsing() throws {

        // Read in the file
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: "ClientPageDataTcd", ofType: "json")!

        let content = try String(contentsOfFile: path)

        // Use objectmapper
        guard let tcdEvents = try? Mapper<ClientPageData>().map(JSONString: content) else {
            XCTFail()
            return
        }

        XCTAssertEqual(tcdEvents.includedPages.count, 325)
    }

}
