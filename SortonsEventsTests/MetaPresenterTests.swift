//
//  MetaPresenterTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 24/01/2017.
//  Copyright © 2017 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest

fileprivate class OutputMock: MetaPresenterOutputProtocol {

    var showFeedbackTypeAlertHit = false
    var showErrorAlertHit = false
    var shareHit = false

    var sendFeedbackEmailHit = false
    var address = ""
    var subject = ""

    func showFeedbackTypeAlert() {
        showFeedbackTypeAlertHit = true
    }

    func showErrorAlert(title: String, message: String) {
        showErrorAlertHit = true
    }

    func share(_ objectsToShare:[Any]) {
        shareHit = true
    }

    func sendFeedbackEmail(to address: String, with subject: String) {
        sendFeedbackEmailHit = true
        self.address = address
        self.subject = subject
    }
}

class MetaPresenterTests: XCTestCase {

    fileprivate var outputMock: OutputMock!
    var presenter: MetaInteractorOutputProtocol!

    override func setUp() {
        super.setUp()

        let fomoId = FomoId(fomoIdNumber: "number",
                                    name: "name",
                               shortName: "shortName",
                                longName: "longName",
                              appStoreId: "appStoreId",
                                  censor: ["censor"])

        outputMock = OutputMock()
        presenter = MetaPresenter(fomoId: fomoId,
                                  output: outputMock)
    }

    func testShare() {
        presenter.share()

        XCTAssert(outputMock.shareHit)
    }

    func testFeedbackAlert() {
        presenter.showFeedbackTypeAlert()

        XCTAssert(outputMock.showFeedbackTypeAlertHit)
    }

    func testSendFeedbackComplaint() {
        presenter.sendFeedback(for: .complaint)

        XCTAssert(outputMock.sendFeedbackEmailHit)

        XCTAssertEqual(outputMock.address, "info@sortons.ie")
        XCTAssertEqual(outputMock.subject, "Complaint")
    }

    func testSendFeedbackSuggestion() {
        presenter.sendFeedback(for: .suggestion)

        XCTAssert(outputMock.sendFeedbackEmailHit)

        XCTAssertEqual(outputMock.address, "info@sortons.ie")
        XCTAssertEqual(outputMock.subject, "Suggestion")
    }

    func testSendFeedbackPraise() {
        presenter.sendFeedback(for: .praise)

        XCTAssert(outputMock.sendFeedbackEmailHit)

        XCTAssertEqual(outputMock.address, "info@sortons.ie")
        XCTAssertEqual(outputMock.subject, "Praise")
    }
}
