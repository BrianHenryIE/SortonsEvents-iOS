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

        // TODO NB Wait for data to load
        // On first load, there's no cache
        // (though it seems like that after multiple runson device!)

        sleep(5)

        table.swipeUp()
        snapshot("ListEvents")

        app.tabBars.buttons["Directory"].tap()

        tablesQuery = self.app.tables
        table = tablesQuery.element
        table.swipeUp()
        snapshot("Directory")

        // hopefuly by now the news tab will have loaded (or a newer version will have better performance)
        app.tabBars.buttons["News"].tap()

        app.windows.element(boundBy: 0) .swipeUp()

        snapshot("News")

        XCTAssert(true)
    }

    override func tearDown() {
        super.tearDown()
    }
}
