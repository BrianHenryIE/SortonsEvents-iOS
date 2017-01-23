//
//  ListEventsNetworkTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 20/01/2017.
//  Copyright © 2017 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest
import Mockingjay
import Alamofire

class ListEventsNetworkTests: XCTestCase {

    var worker: NetworkProtocol!

    override func setUp() {
        super.setUp()

        worker = NetworkWorker<DiscoveredEvent>()
    }

    func testNetworkFetch() {

        let asyncExpectation = expectation(description: "NetworkTests")

        let responseBody = readJsonData(filename: "NetworkTestsData")

        // swiftlint:disable:next line_length
        stub(uri("https://sortonsevents.appspot.com/_ah/api/upcomingEvents/v1/discoveredeventsresponse/fomoId"), jsonData(responseBody))

        worker.fetch("fomoId") {
            (result: Result<[DiscoveredEvent]>) in

            switch result {
            case .success:
                XCTAssert(true)
            default:
                XCTFail()
            }

            asyncExpectation.fulfill()

        }

        self.waitForExpectations(timeout: 5) { error in

            XCTAssertNil(error, "Something went horribly wrong")
        }
    }

}
