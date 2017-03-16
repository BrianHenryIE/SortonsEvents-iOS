//
//  EventsTableViewControllerTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 04/07/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest

private class OutputSpy: ListEventsTableViewControllerOutputProtocol {

    var fetchEventsCalled = false
    var fetchFromNetworkCalled = false
    var displayEventCalled = false
    var changeToNextTabRightCalled = false

    func fetchEvents(_ request: ListEvents.Fetch.Request) {
        fetchEventsCalled = true
    }

    func fetchFromNetwork() {
        fetchFromNetworkCalled = true
    }

    func displayEvent(for eventDataRow: Int) {
        displayEventCalled = true
    }

    func changeToNextTabRight() {
        changeToNextTabRightCalled = true
    }
}

class ListEventsTableViewControllerTests: XCTestCase {

    var viewController: ListEventsTableViewController!
    private var outputSpy: OutputSpy!

    override func setUp() {
        super.setUp()

        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "ListEvents", bundle: bundle)
        viewController = storyboard.instantiateViewController(withIdentifier: "ListEvents")
            as? ListEventsTableViewController

        outputSpy = OutputSpy()
        viewController.output = outputSpy

        _ = viewController.view
    }

    func testShouldFetchEventsWhenViewIsLoaded() {
        XCTAssert(outputSpy.fetchEventsCalled, "Should fetch events when the view is loaded")
    }

    func testPullToRefreshIsEnabled() {
        XCTAssertNotNil(viewController.tableView.refreshControl)
    }

    func testShouldDisplayLoadingIconOnLoad() {
        XCTAssertTrue(viewController.tableView.refreshControl?.isRefreshing ?? false)
    }

    func testLoadingIconShouldRemainWhenCacheReturned() {

        let cells: [ListEvents.ViewModel.Cell] = Array<ListEvents.ViewModel.Cell>()

        let hideRefreshContol = false

        let data = ListEvents.ViewModel(discoveredEvents: cells,
                                        hideRefreshControl: hideRefreshContol)

        viewController.presentFetchedEvents(data)

        XCTAssertTrue(viewController.tableView.refreshControl?.isRefreshing ?? false)
    }

    func testLoadingIconShouldDisappearWhenNetworkReturns() {

        let cells: [ListEvents.ViewModel.Cell] = Array<ListEvents.ViewModel.Cell>()

        let hideRefreshContol = true

        let data = ListEvents.ViewModel(discoveredEvents: cells,
                                          hideRefreshControl: hideRefreshContol)

        viewController.presentFetchedEvents(data)

        XCTAssertFalse(viewController.tableView.refreshControl?.isRefreshing ?? true)
    }

    func testOfflineMessageShouldDisplayWhenAppropriate() {

    }

    func testShouldFetchFromNetworkWhenPulledToRefresh() {

        viewController.refreshControl?.sendActions(for: .valueChanged)

        XCTAssertTrue(outputSpy.fetchFromNetworkCalled)
    }
}
