//
//  NewsViewControllerTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 17/10/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest
import WebKit

fileprivate class OutputSpy: NewsViewControllerOutputProtocol {
    var openUrlCalled = true
    var setupCalled = false
    var changeToNextTabLeftCalled = false
    var changeToNextTabRightCalled = false

    func open(_ url: URL) {

        openUrlCalled = true
    }

    func setup(_ request: News.Request) {
        setupCalled = true
    }

    func changeToNextTabLeft() {
        changeToNextTabLeftCalled = true
    }

    func changeToNextTabRight() {
        changeToNextTabRightCalled = true
    }
}

class WebViewSpy: WKWebView {
    var loadRequestCalled = false
    override func load(_ request: URLRequest) -> WKNavigation? {
        loadRequestCalled = true
        return nil
    }
}

private class WKNavigationActionMock: WKNavigationAction {
    override var request: URLRequest {
        return mockRequest
    }
    override var navigationType: WKNavigationType {
        return mockNavigationType
    }
    let mockRequest: URLRequest
    let mockNavigationType: WKNavigationType
    init(mockRequest: URLRequest, mockNavigationType: WKNavigationType) {
        self.mockRequest = mockRequest
        self.mockNavigationType = mockNavigationType
        super.init()
    }
}

class NewsViewControllerTests: XCTestCase {

    var sut: NewsViewController!
    fileprivate let outputSpy = OutputSpy()
    let webViewSpy = WebViewSpy()

    override func setUp() {
        super.setUp()

        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "News", bundle: bundle)

        sut = storyboard.instantiateViewController(withIdentifier: "News") as? NewsViewController

        sut.output = outputSpy

        // Call viewDidLoad()
        let _ = sut.view
    }

    func testVCSetsUpOnLoad() {
        XCTAssert(outputSpy.setupCalled, "View not initializing as expected – should ping interactor")
    }

    func testWebviewDelegateShouldBeSet() {
        XCTAssert(sut.webview?.navigationDelegate != nil, "Webview delegate not set")
    }

    func testWebViewSetProperly() {
        sut.webview = webViewSpy

        let urlString = "https://www.sortons.ie"
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        let viewModel = News.ViewModel(newsUrl: urlRequest)

        sut.display(viewModel)

        XCTAssert(webViewSpy.loadRequestCalled, "web view not initialised properly")
    }

    func testShouldCallOpenUrlWhenLinkClicked() {

        let urlString = "https://www.sortons.ie"
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)

        let action = WKNavigationActionMock(mockRequest: urlRequest, mockNavigationType: .linkActivated)

        sut.webView(sut.webview!,
                    decidePolicyFor: action,
                    decisionHandler: {_ in })

        XCTAssertTrue(outputSpy.openUrlCalled, "interactor should be called when a link is clicked")
    }
}
