//
//  EventsTableViewControllerTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 04/07/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import XCTest
@testable import SortonsEvents

class ListEventsTableViewControllerOutputSpy : ListEventsTableViewControllerOutput {
    
    var fetchEventsCalled = false

    func fetchEvents(request: ListEvents_FetchEvents_Request) {
          fetchEventsCalled = true
    }
}
class ListEventsTableViewControllerTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: ListEventsTableViewController!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        window = UIWindow()
        setupListOrdersViewController()
    }
    
    override func tearDown()
    {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupListOrdersViewController()
    {
        //let bundle = NSBundle.mainBundle()
        let bundle = NSBundle(forClass: self.classForCoder)
        let storyboard = UIStoryboard(name: "ListEventsStoryboard", bundle: bundle)
        sut = storyboard.instantiateViewControllerWithIdentifier("ListEventsTableViewController") as! ListEventsTableViewController
    }
    
    func testShouldFetchOrdersWhenViewIsLoaded()
    {
        // Given
        let listEventsViewControllerOutputSpy = ListEventsTableViewControllerOutputSpy()
        
        sut.output = listEventsViewControllerOutputSpy
        
        // When
        loadView()
        
        // Then
        XCTAssert(listEventsViewControllerOutputSpy.fetchEventsCalled, "Should fetch events when the view is loaded")
    }
    
    func loadView()
    {
        window.addSubview(sut.view)
        NSRunLoop.currentRunLoop().runUntilDate(NSDate())
    }
    
}
