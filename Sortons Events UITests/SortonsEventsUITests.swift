//
//  Sortons_Events_UITests.swift
//  Sortons Events UITests
//
//  Created by Brian Henry on 28/12/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import XCTest

class SortonsEventsUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        app.launchArguments = [ "USE_PRESENTER_FILTER" ]

        // open the app
        app.launch()
    }

    func testScreenshots() {

        let tablesQuery: XCUIElementQuery = self.app.tables
        let table: XCUIElement = tablesQuery.element
        // TODO wait for data to load

        table.swipeUp()

        // take screenshot

        // with a UI test presenter, whose purpose it is to scrub DCU from society names
        app.tabBars.buttons["Directory"].tap()
        // in the directory tab, scroll down a little
        // take screenshot

        // hopefuly by now the news tab will have loaded (or a newer version will have better performance)
        app.tabBars.buttons["News"].tap()
        
        table.swipeUp()
        // take a screenshot

        // switch to meta
        
        // what about the uitabbar replacement we want to use?!

    }

    override func tearDown() {
        super.tearDown()
    }
}
