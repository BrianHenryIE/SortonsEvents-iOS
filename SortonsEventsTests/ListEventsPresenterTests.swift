//
//  ListEventsPresenterTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/07/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import XCTest
import ObjectMapper

class ListEventsPresenterOutputSpy: ListEventsPresenterOutput {
    
    var presentFetchedEventsCalled = false
    
    func presentFetchedEvents(_ viewModel: ListEventsViewModel) {
        presentFetchedEventsCalled = true
    }
}

class ListEventsPresenterTests: XCTestCase {
    
    var events: [DiscoveredEvent]!
    
    var sut: ListEventsPresenter!
    let spy = ListEventsPresenterOutputSpy()
    
    override func setUp() {
        super.setUp()
       
        // Read in the file
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: "DiscoveredEventsResponseNUIG30June16", ofType: "json")!
        
        do {
            let content = try String(contentsOfFile: path)
            let nuigJun16: DiscoveredEventsResponse = Mapper<DiscoveredEventsResponse>().map(JSONString: content)!
            events = nuigJun16.data
        } catch {
            // stop the tests!
        }
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        var dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        dateComponents.year = 2016
        dateComponents.month = 08
        dateComponents.day = 15
        let date = calendar.date(from: dateComponents)!

        sut = ListEventsPresenter(output: spy, withDate: date, withCalendar: calendar)
    }
    
    func testPresentFetchedEvents() {
        
        sut.presentFetchedEvents(ListEvents_FetchEvents_Response(events: events))
        
        XCTAssertTrue(spy.presentFetchedEventsCalled)        
    }
    
    func testPresentEmptyFetchedEvents() {
        // If there are no events found, it should not push to the next layer
        // becuase it's crashing
        // TODO: ultimately, it should show a polite message
        
        let empty = [DiscoveredEvent]()
        
        sut.presentFetchedEvents(ListEvents_FetchEvents_Response(events: empty))
        
        XCTAssertFalse(spy.presentFetchedEventsCalled)
        
    }

    func testShouldDiscardEarlyEvents() {
        var remainingEvents: [DiscoveredEvent]
        var ourTime: Date
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        
        
        // Test data: 9 total
        
        // 8-endTime: 2016-07-23T20:00:00.000Z
        // 9-startTime: 2016-09-24T09:00:00.000Z
        
        
        dateComponents.year = 2016
        dateComponents.month = 08
        dateComponents.day = 15
        
        ourTime = calendar.date(from: dateComponents)!
        remainingEvents = sut.filterToOngoingEvents(events, observingFrom: ourTime)
        
        XCTAssertEqual(remainingEvents.count, 1, "the wrong number of events were filtered out")
    
        // Events with end times are obvious
        dateComponents.month = 07
        dateComponents.day = 23
        dateComponents.hour = 19
        dateComponents.minute = 00
        
        ourTime = calendar.date(from: dateComponents)!
        remainingEvents = sut.filterToOngoingEvents(events, observingFrom: ourTime)
        
        XCTAssertEqual(remainingEvents.count, 2, "Was the ongoing event properly included?")
 
        // If the event has no end time but started before 6pm, we assume it to be over at midnight
        // 3rd last event has no end time:
        // "startTime": "2016-07-11T09:00:00.000Z",
        dateComponents.day = 11
        dateComponents.hour = 22
        
        ourTime = calendar.date(from: dateComponents)!
        remainingEvents = sut.filterToOngoingEvents(events, observingFrom: ourTime)
        
        XCTAssertEqual(remainingEvents.count, 3, "Event starting today with no end time should be included")
        
        dateComponents.day = 12
        dateComponents.hour = 02
        
        ourTime = calendar.date(from: dateComponents)!
        remainingEvents = sut.filterToOngoingEvents(events, observingFrom: ourTime)
        
        XCTAssertEqual(remainingEvents.count, 2, "Event starting yesterday before 6pm with no end time should not be included")
        
        // If the event has no end time but started after 6pm, we don't remove it until 6am
        // The choice of nighttime cutoff is arbirtary
        // "startTime": "2016-07-23T19:00:00.000Z",
        dateComponents.day = 24
        dateComponents.hour = 02
        
        ourTime = calendar.date(from: dateComponents)!
        remainingEvents = sut.filterToOngoingEvents(events, observingFrom: ourTime)
        
        XCTAssertEqual(remainingEvents.count, 2, "Event starting yesterday after 6pm with no end time should be included until 6am following")

        dateComponents.hour = 08
        
        ourTime = calendar.date(from: dateComponents)!
        remainingEvents = sut.filterToOngoingEvents(events, observingFrom: ourTime)
        
        XCTAssertEqual(remainingEvents.count, 1, "Event starting yesteday after 6pm with no end time should not be included after 6am following")
        
        // Events without end times who start after the test time are just part of the first test
        
        // All day:
        // "startTime": "2016-06-30T00:00:00.000Z",
        // "dateOnly": true,
        dateComponents.month = 06
        dateComponents.day = 30
        dateComponents.hour = 19
        dateComponents.minute = 00
        
        ourTime = calendar.date(from: dateComponents)!
        remainingEvents = sut.filterToOngoingEvents(events, observingFrom: ourTime)
        
        XCTAssertEqual(remainingEvents.count, 9, "All day events starting today should be included")
        
        dateComponents.month = 07
        dateComponents.day = 01
        
        ourTime = calendar.date(from: dateComponents)!
        remainingEvents = sut.filterToOngoingEvents(events, observingFrom: ourTime)
        
        XCTAssertEqual(remainingEvents.count, 7, "All day events starting yesterday should not be included")
        
        
        dateComponents.month = 01
        dateComponents.day = 01
        
        ourTime = calendar.date(from: dateComponents)!
        remainingEvents = sut.filterToOngoingEvents(events, observingFrom: ourTime)
        
        XCTAssertEqual(remainingEvents.count, 9, "Everything in the future (no filter!)")
    }
    
    // Move to NSDate extension
    func testFormatFriendlyTime() {
        
        // Testing times: 2016-06-30T20:00:00.000Z
        let displayDate = events[1].startTime
        
        var ourTime: Date
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        
        //  what about timezones? (we'll see once we get to California!)
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        
        // 1. A normal "not close" date format
        var expected = "Thursday 30 June at 20:00"
        var formatted = sut.formatFriendlyTime(displayDate!, allDay: false, observingFrom: Date())
        
        XCTAssertEqual(expected, formatted, "Most basic formatted time is wrong!")
        
        // as all day event
        expected = "Thursday 30 June"
        formatted = sut.formatFriendlyTime(displayDate!, allDay : true, observingFrom: Date())
        
        XCTAssertEqual(expected, formatted, "Most basic all-day formatted time is wrong!")
        
        // 2. What about xxx 05 June... should it have the 0 or not? (aesthetically)
        
        // 3. Pretend it's 29 June and the event is tomorrow!
        dateComponents.year = 2016
        dateComponents.month = 06
        dateComponents.day = 29
        
        ourTime = calendar.date(from: dateComponents)!
        
        expected = "Tomorrow at 20:00"
        formatted = sut.formatFriendlyTime(displayDate!, allDay : false, observingFrom: ourTime)
        
        XCTAssertEqual(expected, formatted, "Tomorrow's formatted time is wrong!")
        
        // as all day event
        expected = "Tomorrow"
        formatted = sut.formatFriendlyTime(displayDate!, allDay : true, observingFrom: ourTime)
        
        XCTAssertEqual(expected, formatted, "Tomorrow's all-day formatted time is wrong!")
        
        // 4. Pretend it's 30 June and the event is today
        dateComponents.month = 06
        dateComponents.day = 30
        
        ourTime = calendar.date(from: dateComponents)!
        
        expected = "Today at 20:00"
        formatted = sut.formatFriendlyTime(displayDate!, allDay : false, observingFrom: ourTime)
        
        XCTAssertEqual(expected, formatted, "Today's formatted time is wrong!")
       
        // as all day event
        expected = "Today"
        formatted = sut.formatFriendlyTime(displayDate!, allDay : true, observingFrom: ourTime)
        
        XCTAssertEqual(expected, formatted, "Today's all-day formatted time is wrong!")
        
        // 5. Pretend it's 1 July and the event was yesterday
        dateComponents.month = 07
        dateComponents.day = 01
        
        ourTime = calendar.date(from: dateComponents)!
        
        expected = "Yesterday at 20:00"
        formatted = sut.formatFriendlyTime(displayDate!, allDay : false, observingFrom: ourTime)
        
        XCTAssertEqual(expected, formatted, "Yesterday's formatted time is wrong!")
        
        // as all day event (I'm not sure if this one is posisble!)
        expected = "Yesterday"
        formatted = sut.formatFriendlyTime(displayDate!, allDay : true, observingFrom: ourTime)
        
        XCTAssertEqual(expected, formatted, "Yesterday's all-day formatted time is wrong!")
    }
}
