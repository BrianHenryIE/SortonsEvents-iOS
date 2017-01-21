//
//  EventsTableViewControllerTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 04/07/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest

fileprivate class OutputSpy: ListEventsTableViewControllerOutputProtocol {

    var fetchEventsCalled = false
    var displayEventCalled = false
    var changeToNextTabRightCalled = false

    func fetchEvents(_ request: ListEvents.Fetch.Request) {
        fetchEventsCalled = true
    }

    internal func displayEvent(for eventDataRow: Int) {
        displayEventCalled = true
    }

    func changeToNextTabRight() {
        changeToNextTabRightCalled = true
    }
}

class ListEventsTableViewControllerTests: XCTestCase {

    // MARK: Subject under test

    var sut: ListEventsTableViewController!
    var window: UIWindow!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupListOrdersViewController()
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    // MARK: Test setup
    func setupListOrdersViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "ListEvents", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "ListEvents") as? ListEventsTableViewController
    }

    func testShouldFetchOrdersWhenViewIsLoaded() {
        // Given
        let outputSpy = OutputSpy()

        sut.output = outputSpy

        // When
        // Call viewDidLoad()
        let _ = sut.view

        // Then
        XCTAssert(outputSpy.fetchEventsCalled, "Should fetch events when the view is loaded")
    }

}
