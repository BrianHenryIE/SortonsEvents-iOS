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

        setupSnapshot(app)

        app.launch()
    }

    func testScreenshots() {

        var tablesQuery: XCUIElementQuery = self.app.tables
        var table: XCUIElement = tablesQuery.element

        sleep(10)

        table.swipeUp()
        sleep(3)
        snapshot("ListEvents")

        app.tabBars.buttons["Directory"].tap()

        tablesQuery = self.app.tables
        table = tablesQuery.element
        table.swipeUp()
        sleep(3)
        snapshot("Directory")

        // hopefuly by now the news tab will have loaded (or a newer version will have better performance)
        app.tabBars.buttons["News"].tap()

        app.windows.element(boundBy: 0).swipeUp()
        sleep(3)
        snapshot("News")

        XCTAssert(true)
    }

    override func tearDown() {
        super.tearDown()
    }
}
