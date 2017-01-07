//
//  MetaWebViewTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 06/01/2017.
//  Copyright © 2017 Sortons. All rights reserved.
//

import XCTest
@testable import SortonsEvents

fileprivate class PresenterOuputMock: MetaWebViewPresenterOuput {
    var displayInWebViewHit = false
    func displayInWebView(processedHtml: String) {
        displayInWebViewHit = true
    }
}

fileprivate class InteractorOuputMock: MetaWebViewInteractorOuput {
    var displayHtmlHit = false
    var htmlContent: String!
    func displayHtml(html: String) {
        displayHtmlHit = true
        htmlContent = html
    }
}

class MetaWebViewTests: XCTestCase {

    var fomoId: FomoId!
    fileprivate var presenterOuputMock: PresenterOuputMock!
    var presenterUnderTest: MetaWebViewPresenter!

    override func setUp() {
        super.setUp()

        presenterOuputMock = PresenterOuputMock()

        fomoId = FomoId(id: "160571590941928",
                      name: "FOMO UCC",
                 shortName: "UCC",
                  longName: "University College Cork",
                appStoreId: "1035132261",
                    censor: [""])

        presenterUnderTest = MetaWebViewPresenter(with: presenterOuputMock, fomoId: fomoId)
    }

    func testPresenterStringReplacement() {

        let testStringBefore = "<p>Events and news aggregator for <fomo:longName>. Don't miss out!</p><p>Compiles all the latest events and posts from over 350 <fomo:shortName> Facebook pages.</p>"

        let testStringAfter = "<p>Events and news aggregator for University College Cork. Don't miss out!</p><p>Compiles all the latest events and posts from over 350 UCC Facebook pages.</p>"

        let processedFromBefore = presenterUnderTest.replaceFomoNameIn(html: testStringBefore,
                                                      fomoId: fomoId)

        XCTAssertEqual(testStringAfter, processedFromBefore)
    }

    func testPresenterOutputsToView() {
        presenterUnderTest.displayHtml(html: "testing")

        XCTAssertTrue(presenterOuputMock.displayInWebViewHit)
    }

    func testInteractorOutput() {

        let interactorOutputMock = InteractorOuputMock()

        let sut = MetaWebViewInteractor(with: interactorOutputMock,
                                         for: "http://sortons.ie/events/changelog.html")

        sut.loadHtml()

        XCTAssertTrue(interactorOutputMock.displayHtmlHit)
    }
}
