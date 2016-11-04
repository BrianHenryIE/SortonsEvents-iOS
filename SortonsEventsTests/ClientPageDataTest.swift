//
//  ClientPageDataTest.swift
//  SortonsEvents
//
//  Created by Brian Henry on 30/06/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import XCTest
@testable import SortonsEvents
import ObjectMapper

class ClientPageDataTest: XCTestCase {

    func testClientPageDataParsing() throws {
        
        // Read in the file
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: "ClientPageDataTcd", ofType: "json")!
        
        let content = try String(contentsOfFile: path)
        
        // Use objectmapper
        let tcdEvents: ClientPageData = Mapper<ClientPageData>().map(JSONString: content)!
        
        XCTAssertEqual(tcdEvents.includedPages.count, 325)
    }
    
    func testCaliforniaNil() throws {
        
        // Read in the file
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: "TcdCaliforniaAlumni", ofType: "json")!
        
        let content = try String(contentsOfFile: path)
        
        // Use objectmapper
        let california: SourcePage = Mapper<SourcePage>().map(JSONString: content)!
        
        
        XCTAssertEqual(california.fbPageId, "1538569619693874")
    }
    
}
