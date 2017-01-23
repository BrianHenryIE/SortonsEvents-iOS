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

    func testTcdAsianJsonParsing() {

        let content = readJsonFile(filename: "SourcePageTcdAsian")

        guard let tcdAsian = try? Mapper<SourcePage>().map(JSONString: content) else {
            XCTFail("Parse error")
            return
        }

        XCTAssertEqual(tcdAsian.name, "Trinity Centre for Asian Studies")
        XCTAssertEqual(tcdAsian.fbPageId, "691002424327686")

        XCTAssertEqual(tcdAsian.pageUrl, "https://www.facebook.com/TCD.Asian")
        XCTAssertEqual(tcdAsian.street, "")
        XCTAssertEqual(tcdAsian.city, "Dublin")
        XCTAssertEqual(tcdAsian.country, "Ireland")
        XCTAssertEqualWithAccuracy(tcdAsian.latitude!, 53.34306046, accuracy: 10)
        XCTAssertEqualWithAccuracy(tcdAsian.longitude!, -6.25663396, accuracy: 10)
        XCTAssertEqual(tcdAsian.zip, "D2")
        XCTAssertEqual(tcdAsian.friendlyLocationString, "Dublin, D2, Ireland")

    }

    func testTcdCaliforniaAlumniParsing() {

        let content = readJsonFile(filename: "SourcePageTcdCaliforniaAlumni")

        guard let tcdCalifornia = try? Mapper<SourcePage>().map(JSONString: content) else {
            XCTFail("Parse error")
            return
        }

        XCTAssertEqual(tcdCalifornia.name, "Trinity College Dublin California Alumni.")
        XCTAssertEqual(tcdCalifornia.fbPageId, "1538569619693874")
        XCTAssertEqual(tcdCalifornia.pageUrl, "https://www.facebook.com/Trinity-College-Dublin-California-Alumni-1538569619693874/")

        XCTAssertEqual(tcdCalifornia.friendlyLocationString, "")
    }

    func testNUIGRugbyAcademyParsing() {

        let content = readJsonFile(filename: "SourcePageNUIGRugbyAcademy")

        guard let nuigRugby = try? Mapper<SourcePage>().map(JSONString: content) else {
            XCTFail("Parse error")
        return
        }

        XCTAssertEqual(nuigRugby.name, "NUI Galway Rugby Academy")
        XCTAssertEqual(nuigRugby.pageUrl, "https://www.facebook.com/pages/NUI-Galway-Rugby-Academy/152440711506112")
        XCTAssertEqual(nuigRugby.street, "C/O Gearoid O Broin,The Quad, NUI Galway.")
        XCTAssertEqual(nuigRugby.city, "Galway")
        XCTAssertEqual(nuigRugby.country, "Ireland")
        XCTAssertEqual(nuigRugby.zip, "Galway")
    }

    func testCaliforniaNil() throws {

        let content = readJsonFile(filename: "SourcePageTcdCaliforniaAlumni")

        // Use objectmapper
        guard let california: SourcePage = try? Mapper<SourcePage>().map(JSONString: content) else {
            XCTFail()
            return
        }

        XCTAssertEqual(california.fbPageId, "1538569619693874")
    }
}

extension XCTestCase {

    /**
     * Reads filename of type json
     * Fails and stops the test if the file can't be read
     */
    func readJsonFile(filename: String) -> String {
        let bundle = Bundle(for: self.classForCoder)
        guard let path = bundle.path(forResource: filename, ofType: "json"),
            let content = try? String(contentsOfFile: path) else {
                continueAfterFailure = false
                XCTFail("File error")
                return ""
        }
        return content
    }
}
