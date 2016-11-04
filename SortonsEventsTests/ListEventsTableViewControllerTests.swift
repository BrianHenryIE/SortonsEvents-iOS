//
//  EventsTableViewControllerTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 04/07/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import XCTest
@testable import SortonsEvents

class ListEventsTableViewControllerOutputSpy: ListEventsTableViewControllerOutput {

    var fetchEventsCalled = false
    var displayEventCalled = false
    var changeToNextTabRightCalled = false

    func fetchEvents(_ request: ListEvents_FetchEvents_Request) {
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
        sut = storyboard.instantiateViewController(withIdentifier: "ListEvents") as! ListEventsTableViewController
    }
    
    func testShouldFetchOrdersWhenViewIsLoaded() {
        // Given
        let listEventsViewControllerOutputSpy = ListEventsTableViewControllerOutputSpy()
        
        sut.output = listEventsViewControllerOutputSpy
        
        // When
        // Call viewDidLoad()
        let _ = sut.view
        
        // Then
        XCTAssert(listEventsViewControllerOutputSpy.fetchEventsCalled, "Should fetch events when the view is loaded")
    }
    
}
