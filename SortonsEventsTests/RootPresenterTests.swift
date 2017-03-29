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
    var viewData: Root.ViewModel.Banner?

    func animateNotice(with viewData: Root.ViewModel.Banner) {
        animateNoticeHit = true
        self.viewData = viewData
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
        XCTAssertEqual(outputMock.viewData!.containerHeight, 66)
        XCTAssertEqual(outputMock.viewData!.alpha, 1.0)
        XCTAssertEqual(outputMock.viewData!.title, "No Network Connection")
    }

    func testShowOnlineNotice() {

        rootPresenter.showOnlineNotice()

        waitForExpectations(timeout:2, handler: nil)

        XCTAssertTrue(outputMock.animateNoticeHit)
        XCTAssertEqual(outputMock.viewData!.containerHeight, 0)
        XCTAssertEqual(outputMock.viewData!.alpha, 0)
        XCTAssertEqual(outputMock.viewData!.title, "Connection Successful")
    }
}
