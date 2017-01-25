//
//  MetaWebViewTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 06/01/2017.
//  Copyright © 2017 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest

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
    fileprivate var presenterOutputMock: PresenterOuputMock!
    var presenter: MetaWebViewPresenter!

    override func setUp() {
        super.setUp()

        presenterOutputMock = PresenterOuputMock()

        fomoId = FomoId(fomoIdNumber: "160571590941928",
                                name: "FOMO UCC",
                           shortName: "UCC",
                            longName: "University College Cork",
                          appStoreId: "1035132261",
                              censor: [""])

        presenter = MetaWebViewPresenter(with: presenterOutputMock, fomoId: fomoId)
    }

    func testPresenterStringReplacement() {

        // swiftlint:disable:next line_length
        let testStringBefore = "<p>Events and news aggregator for <fomo:longName>. Don't miss out!</p><p>Compiles all the latest events and posts from over 350 <fomo:shortName> Facebook pages.</p>"

        // swiftlint:disable:next line_length
        let testStringAfter = "<p>Events and news aggregator for University College Cork. Don't miss out!</p><p>Compiles all the latest events and posts from over 350 UCC Facebook pages.</p>"

        let processedFromBefore = presenter.replaceFomoNameIn(html: testStringBefore,
                                                            fomoId: fomoId)

        XCTAssertEqual(testStringAfter, processedFromBefore)
    }

    func testPresenterOutputsToView() {
        presenter.displayHtml(html: "testing")

        XCTAssertTrue(presenterOutputMock.displayInWebViewHit)
    }

    func testInteractorOutput() {

        let outputMock = InteractorOuputMock()

        let sut = MetaWebViewInteractor(with: outputMock,
                                         for: "http://sortons.ie/events/changelog.html")

        sut.loadHtml()

        XCTAssertTrue(outputMock.displayHtmlHit)
    }
}
