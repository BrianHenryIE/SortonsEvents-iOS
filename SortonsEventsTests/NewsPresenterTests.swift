//
//  NewsPresenterTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 17/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import XCTest
@testable import SortonsEvents

class NewsPresenterOutputSpy: NewsPresenterOutput {
    
    var displayCalled = false
    var url: String?
    func display(viewModel: News.ViewModel) {
        displayCalled = true
        url = viewModel.newsUrl.url?.absoluteString
    }
}

class NewsPresenterTests: XCTestCase {
    
    let spy = NewsPresenterOutputSpy()
    var sut: NewsPresenter!
    
    override func setUp() {
        super.setUp()
       
        sut = NewsPresenter(output: spy)
    }
    
    func testPresenterOutput() {
        
        sut.setFomoId("123")
        
        XCTAssert(spy.displayCalled, "display not called by presenter")
        XCTAssertEqual(spy.url, "https://sortonsevents.appspot.com/recentpostsmobile/news.html#123", "incorrect URL built by presenter")
    }
    
}
