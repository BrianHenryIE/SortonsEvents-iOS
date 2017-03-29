//
//  NewsPresenterTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 17/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest

fileprivate class OutputMock: NewsPresenterOutputProtocol {

    var asyncExpectation: XCTestExpectation?

    var displayCalled = false
    var url: String?

    func display(_ viewModel: News.ViewModel) {
        displayCalled = true
        url = viewModel.newsUrlRequest.url?.absoluteString
        asyncExpectation?.fulfill()
    }
}

class NewsPresenterTests: XCTestCase {

    fileprivate let outputMock = OutputMock()
    var sut: NewsPresenter!

    override func setUp() {
        super.setUp()

        let asyncExpectation = expectation(description: "NewsPresenterTests")
        outputMock.asyncExpectation = asyncExpectation

        sut = NewsPresenter(output: outputMock)
    }

    func testPresenterOutput() {

        sut.setFomoId("123")

        waitForExpectations(timeout:5, handler: nil)

        XCTAssert(outputMock.displayCalled, "display not called by presenter")
        XCTAssertEqual(outputMock.url,
                       "http://sortons.ie/events/recentpostsmobile/news.html#123",
                       "incorrect URL built by presenter")
    }

}
