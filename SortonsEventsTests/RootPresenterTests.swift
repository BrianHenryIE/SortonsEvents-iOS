//
//  RootPresenterTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 3/28/17.
//  Copyright © 2017 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest

private class OutputMock: RootPresenterOutput {

    var asyncExpectation: XCTestExpectation?

    var animateNoticeHit = false
    var title: String?
    var isVisible: Bool?

    func animateNotice(with title: String, isVisible: Bool) {
        animateNoticeHit = true
        self.title = title
        self.isVisible = isVisible
        asyncExpectation?.fulfill()
    }
}

class RootPresenterTests: XCTestCase {

    var rootPresenter: RootPresenter!
    private var outputMock: OutputMock!

    override func setUp() {
        super.setUp()

        outputMock = OutputMock()
        rootPresenter = RootPresenter(output: outputMock)

        let asyncExpectation = expectation(description: "RootPresenterTests")
        outputMock.asyncExpectation = asyncExpectation
    }

    func testShowOfflineNotice() {

        rootPresenter.showOfflineNotice()

        waitForExpectations(timeout:2, handler: nil)

        XCTAssertTrue(outputMock.animateNoticeHit)
        XCTAssertTrue(outputMock.isVisible!)
        XCTAssertEqual(outputMock.title!, "No Network Connection")
    }

    func testShowOnlineNotice() {

        rootPresenter.showOnlineNotice()

        waitForExpectations(timeout:2, handler: nil)

        XCTAssertTrue(outputMock.animateNoticeHit)
        XCTAssertFalse(outputMock.isVisible!)
        XCTAssertEqual(outputMock.title!, "Connection Successful")
    }
}
