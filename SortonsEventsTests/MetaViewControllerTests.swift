//
//  MetaViewControllerTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 24/01/2017.
//  Copyright © 2017 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest

fileprivate class OutputMock: MetaViewControllerOutputProtocol {

    var sendFeedbackHit = false
    var selectedCellHit = false

    func sendFeedback(for type: FeedbackType) {
        sendFeedbackHit = true
    }

    func selectedCell(at indexPath: IndexPath) {
        selectedCellHit = true
    }
}

class MetaViewControllerTests: XCTestCase {

    fileprivate var outputMock: OutputMock!
    var viewController: MetaViewController!

    override func setUp() {
        super.setUp()

        outputMock = OutputMock()

        viewController = MetaViewController()
        viewController.output = outputMock

        // Call viewDidLoad()
        let _ = viewController.view
    }

    func testExample() {

        viewController.tableView(viewController.tableView, didSelectRowAt: IndexPath(row:0, section:0))

        XCTAssert(outputMock.selectedCellHit)
    }

}
