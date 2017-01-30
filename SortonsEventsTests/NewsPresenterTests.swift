//
//  NewsPresenterTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 17/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest

fileprivate class OutputSpy: NewsPresenterOutputProtocol {

    var displayCalled = false
    var url: String?
    func display(_ viewModel: News.ViewModel) {
        displayCalled = true
        url = viewModel.newsUrlRequest.url?.absoluteString
    }
}

class NewsPresenterTests: XCTestCase {

    fileprivate let outputSpy = OutputSpy()
    var sut: NewsPresenter!

    override func setUp() {
        super.setUp()

        sut = NewsPresenter(output: outputSpy)
    }

    func testPresenterOutput() {

        sut.setFomoId("123")

        XCTAssert(outputSpy.displayCalled, "display not called by presenter")
        XCTAssertEqual(outputSpy.url,
                       "http://sortons.ie/events/recentpostsmobile/news.html#123",
                       "incorrect URL built by presenter")
    }

}
