//
//  NewsViewControllerTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 17/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import XCTest
@testable import SortonsEvents

class NewsViewControllerOutputSpy: NewsViewControllerOutput {
    var setupCalled = false
    var changeToNextTabLeftCalled = false
    var changeToNextTabRightCalled = false
    
    func setup(request: News.Fetch.Request) {
        setupCalled = true
    }
    
    func changeToNextTabLeft() {
        changeToNextTabLeftCalled = true
    }
    
    func changeToNextTabRight() {
        changeToNextTabRightCalled = true
    }
}

class WebViewSpy: UIWebView {
    var loadRequestCalled = false
    override func loadRequest(_ request: URLRequest) {
        loadRequestCalled = true
    }
}

class NewsViewControllerTests: XCTestCase {
    
    var sut: NewsViewController!
    let vcSpy = NewsViewControllerOutputSpy()
    let webViewSpy = WebViewSpy()
    
    override func setUp() {
        super.setUp()
        
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "News", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "News") as? NewsViewController
        
        sut.output = vcSpy
        
        // Call viewDidLoad()
        let _ = sut.view
    }

    func testVCSetsUpOnLoad() {
        XCTAssert(vcSpy.setupCalled, "View not initializing as expected – should ping interactor")

    }
    
    func testWebViewSetProperly() {
        sut.webView = webViewSpy
        
        let urlString = "https://www.sortons.ie"
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        let viewModel = News.ViewModel(newsUrl: urlRequest)
        
        sut.display(viewModel: viewModel)
        
        XCTAssert(webViewSpy.loadRequestCalled, "web view not initialised properly")
    }
}
