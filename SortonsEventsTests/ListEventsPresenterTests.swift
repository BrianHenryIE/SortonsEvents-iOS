//
//  ListEventsPresenterTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/07/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest
import ObjectMapper

fileprivate class OutputSpy: ListEventsPresenterOutputProtocol {

    var presentFetchedEventsCalled = false
    var presentFetchEventsFetchError  = false

    func presentFetchedEvents(_ viewModel: ListEvents.ViewModel) {
        presentFetchedEventsCalled = true
    }

    func displayFetchEventsFetchError(_ viewModel: ListEvents.ViewModel) {
        presentFetchEventsFetchError = true
    }
}

class ListEventsPresenterTests: XCTestCase {

    var sut: ListEventsPresenter!
    fileprivate let outputSpy = OutputSpy()
    var events = [DiscoveredEvent]()

    override func setUp() {
        super.setUp()

        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        sut = ListEventsPresenter(output: outputSpy, calendar: calendar)
    }

    func testPresentFetchedEvents() throws {

        // Read in the file
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: "DiscoveredEventNIUGBicycleVolunteering", ofType: "json")!
        let content = try String(contentsOfFile: path)

        // Use objectmapper
        guard let anEvent: DiscoveredEvent = try? Mapper<DiscoveredEvent>().map(JSONString: content) else {
            XCTFail()
            return
        }

        events.append(anEvent)

        sut.presentFetchedEvents(ListEvents.Fetch.Response(events: events))

        XCTAssertTrue(outputSpy.presentFetchedEventsCalled)
    }

    func testPresentEmptyFetchedEvents() {

    }

    // Move to NSDate extension
    func testFormatFriendlyTime() {

        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!

        var dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        dateComponents.year = 2016
        dateComponents.month = 06
        dateComponents.day = 30
        dateComponents.hour = 20

        // Testing times: 2016-06-30T20:00:00.000Z
        let displayDate = calendar.date(from: dateComponents)!

        var ourTime = Date()

        //  what about timezones? (we'll see once we get to California!)
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")

        // 1. A normal "not close" date format
        var expected = "Thursday 30 June at 20:00"
        var formatted = sut.formatFriendlyTime(displayDate, allDay: false, observingFrom: Date())

        XCTAssertEqual(expected, formatted, "Most basic formatted time is wrong!")

        // as all day event
        expected = "Thursday 30 June"
        formatted = sut.formatFriendlyTime(displayDate, allDay : true, observingFrom: Date())

        XCTAssertEqual(expected, formatted, "Most basic all-day formatted time is wrong!")

        // 2. What about xxx 05 June... should it have the 0 or not? (aesthetically)

        // 3. Pretend it's 29 June and the event is tomorrow!
        dateComponents.year = 2016
        dateComponents.month = 06
        dateComponents.day = 29

        ourTime = calendar.date(from: dateComponents)!

        expected = "Tomorrow at 20:00"
        formatted = sut.formatFriendlyTime(displayDate, allDay : false, observingFrom: ourTime)

        XCTAssertEqual(expected, formatted, "Tomorrow's formatted time is wrong!")

        // as all day event
        expected = "Tomorrow"
        formatted = sut.formatFriendlyTime(displayDate, allDay : true, observingFrom: ourTime)

        XCTAssertEqual(expected, formatted, "Tomorrow's all-day formatted time is wrong!")

        // 4. Pretend it's 30 June and the event is today
        dateComponents.month = 06
        dateComponents.day = 30

        ourTime = calendar.date(from: dateComponents)!

        expected = "Today at 20:00"
        formatted = sut.formatFriendlyTime(displayDate, allDay : false, observingFrom: ourTime)

        XCTAssertEqual(expected, formatted, "Today's formatted time is wrong!")

        // as all day event
        expected = "Today"
        formatted = sut.formatFriendlyTime(displayDate, allDay : true, observingFrom: ourTime)

        XCTAssertEqual(expected, formatted, "Today's all-day formatted time is wrong!")

        // 5. Pretend it's 1 July and the event was yesterday
        dateComponents.month = 07
        dateComponents.day = 01

        ourTime = calendar.date(from: dateComponents)!

        expected = "Yesterday at 20:00"
        formatted = sut.formatFriendlyTime(displayDate, allDay : false, observingFrom: ourTime)

        XCTAssertEqual(expected, formatted, "Yesterday's formatted time is wrong!")

        // as all day event (I'm not sure if this one is posisble!)
        expected = "Yesterday"
        formatted = sut.formatFriendlyTime(displayDate, allDay : true, observingFrom: ourTime)

        XCTAssertEqual(expected, formatted, "Yesterday's all-day formatted time is wrong!")
    }
}
