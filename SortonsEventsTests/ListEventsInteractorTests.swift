//
//  EventsInteractorTests.swift
//  Sortons Events
//
//  Created by Brian Henry on 05/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

// swiftlint:disable line_length

@testable import SortonsEvents
import XCTest
import ObjectMapper

class EmptyListEventsNetworkWorkerSpy: ListEventsNetworkWorker {

    // MARK: Method call expectations
    var fetchEventsCalled = false

    // MARK: Spied methods
    override func fetchEvents(_ fomoId: String, completionHandler: @escaping (_ discoveredEventsJsonPage: String) -> Void) {

        fetchEventsCalled = true
        completionHandler("{}")
    }
}

class EmptyListEventsCacheWorkerSpy: ListEventsCacheWorkerProtocol {

    var fetchCalled = false

    func fetch() -> String? {
        fetchCalled = true
        return "{}" // should I bother?
    }

    var saveCalled = false

    func save(_ latestDiscoveredEvents: String) {
        saveCalled = true
    }
}

class ListEventsNetworkWorkerSpy: ListEventsNetworkWorker {

    // MARK: Method call expectations
    var fetchEventsCalled = false

    // MARK: Spied methods
    override func fetchEvents(_ fomoId: String, completionHandler: @escaping (_ discoveredEventsJsonPage: String) -> Void) {

        fetchEventsCalled = true
        completionHandler("{\"data\": [{\"eventId\": \"918777258231182\",\"clientId\": \"1049082365115363\",\"sourcePages\": [{\"clientId\": \"1049082365115363\",\"id\": \"1049082365115363457660710939203\",\"about\": \"NUI Galway's Student Volunteering Programme www.nuigalway.ie/alive\",\"name\": \"Alive Nuigalway\",\"pageId\": \"457660710939203\",\"pageUrl\": \"https://www.facebook.com/alive.nuigalway\",\"street\": \"\",\"zip\": \"\",\"uid\": \"457660710939203\",\"title\": \"Alive Nuigalway\",\"subTitle\": \"\",\"friendlyLocationString\": \"\",\"searchableString\": \"Alive Nuigalway null null Alive Nuigalway null \",\"class\": \"ie.sortons.events.shared.SourcePage\"}],\"name\": \"Information Evening for Volunteering with Galway's Community Bicycle Workshop\",\"location\": \"Block R, Earls Island, University Road, Galway.\",\"startTime\": \"2016-06-30T18:00:00.000Z\",\"endTime\": \"2016-06-30T19:00:00.000Z\",\"dateOnly\": false}]}")
    }
}

class ListEventsCacheWorkerSpy: ListEventsCacheWorkerProtocol {

    var fetchCalled = false

    func fetch() -> String? {
        fetchCalled = true
        return "{\"data\": [{\"eventId\": \"918777258231182\",\"clientId\": \"1049082365115363\",\"sourcePages\": [{\"clientId\": \"1049082365115363\",\"id\": \"1049082365115363457660710939203\",\"about\": \"NUI Galway's Student Volunteering Programme www.nuigalway.ie/alive\",\"name\": \"Alive Nuigalway\",\"pageId\": \"457660710939203\",\"pageUrl\": \"https://www.facebook.com/alive.nuigalway\",\"street\": \"\",\"zip\": \"\",\"uid\": \"457660710939203\",\"title\": \"Alive Nuigalway\",\"subTitle\": \"\",\"friendlyLocationString\": \"\",\"searchableString\": \"Alive Nuigalway null null Alive Nuigalway null \",\"class\": \"ie.sortons.events.shared.SourcePage\"}],\"name\": \"Information Evening for Volunteering with Galway's Community Bicycle Workshop\",\"location\": \"Block R, Earls Island, University Road, Galway.\",\"startTime\": \"2016-06-30T18:00:00.000Z\",\"endTime\": \"2016-06-30T19:00:00.000Z\",\"dateOnly\": false}]}" // should I bother?
    }

    var saveCalled = false

    func save(_ latestDiscoveredEvents: String) {
        saveCalled = true
    }
}

class ListEventsInteractorOutputSpy: ListEventsInteractorOutput {

    var presentFetchedEventsCalled = false

    func presentFetchedEvents(_ upcomingEvents: ListEvents.Fetch.Response) {
        presentFetchedEventsCalled = true
    }
}

class ListEventsInteractorTests: XCTestCase {

    let fomoId = FomoId(id: "id", name: "name", shortName: "shortName", appStoreId: "appStoreId", censor: [String]())

    func testFetchEventsShouldAskEventsNetworkWorkerToFetchEventsAndPresenterToFormatResult() {
        let listEventsNetworkWorkerSpy = ListEventsNetworkWorkerSpy()
        let listEventsCacheWorkerSpy = ListEventsCacheWorkerSpy()

        let listEventsInteractorOutputSpy = ListEventsInteractorOutputSpy()

        let sut = ListEventsInteractor(wireframe: ListEventsWireframe(fomoId: fomoId),
                                       fomoId: "",
                                       output: listEventsInteractorOutputSpy,
                                       listEventsNetworkWorker: listEventsNetworkWorkerSpy,
                                       listEventsCacheWorker: listEventsCacheWorkerSpy)

        // When
        let request = ListEvents.Fetch.Request()
        sut.fetchEvents(request)

        // Then
        XCTAssert(listEventsCacheWorkerSpy.fetchCalled, "Fetch() should ask ListEventsCacheWorker to fetch events")
        XCTAssert(listEventsNetworkWorkerSpy.fetchEventsCalled, "FetchEvents() should ask EventsNetworkWorker to fetch events")

        XCTAssert(listEventsCacheWorkerSpy.saveCalled, "When network worker returns new data, the cache save() should be called")

        // This only gets called when there are events to return... test for both scenarios!
        XCTAssert(listEventsInteractorOutputSpy.presentFetchedEventsCalled, "FetchEvents() should ask presenter to format events result")
    }

    func testEmptyFetchEventsShouldNotHitPresenter() {
        let emptyListEventsNetworkWorkerSpy = EmptyListEventsNetworkWorkerSpy()
        let emptyListEventsCacheWorkerSpy = EmptyListEventsCacheWorkerSpy()

        let listEventsInteractorOutputSpy = ListEventsInteractorOutputSpy()

        let sut = ListEventsInteractor(wireframe: ListEventsWireframe(fomoId: fomoId),
                                       fomoId: "",
                                       output: listEventsInteractorOutputSpy,
                                       listEventsNetworkWorker: emptyListEventsNetworkWorkerSpy,
                                       listEventsCacheWorker: emptyListEventsCacheWorkerSpy)

        // When
        let request = ListEvents.Fetch.Request()
        sut.fetchEvents(request)

        // Then
        XCTAssert(emptyListEventsCacheWorkerSpy.fetchCalled, "Fetch() should ask ListEventsCacheWorker to fetch events")
        XCTAssert(emptyListEventsNetworkWorkerSpy.fetchEventsCalled, "FetchEvents() should ask EventsNetworkWorker to fetch events")

        XCTAssert(!emptyListEventsCacheWorkerSpy.saveCalled, "If the network worker was empty, no need to save to cache (or would overwrite a possibly valid cache)")

        XCTAssert(!listEventsInteractorOutputSpy.presentFetchedEventsCalled, "FetchEvents() should not ask presenter to format events result")
    }

    func testShouldDiscardEarlyEvents() {
        var remainingEvents: [DiscoveredEvent]
        var ourTime: Date
        var calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        calendar.timeZone = TimeZone(abbreviation: "UTC")!

        let listEventsInteractorOutputSpy = ListEventsInteractorOutputSpy()

        let sut = ListEventsInteractor(wireframe: ListEventsWireframe(fomoId: fomoId),
                                       fomoId: "",
                                       output: listEventsInteractorOutputSpy,
                                       listEventsNetworkWorker: EmptyListEventsNetworkWorkerSpy(),
                                       listEventsCacheWorker: ListEventsCacheWorkerSpy(),
                                       withDate: Date(),
                                       withCalendar: calendar)

        var getEvents: [DiscoveredEvent]!

        // Read in the file
        let bundle = Bundle(for: self.classForCoder)
        let path = bundle.path(forResource: "DiscoveredEventsResponseNUIG30June16", ofType: "json")!

        do {
            let content = try String(contentsOfFile: path)
            let nuigJun16: DiscoveredEventsResponse = Mapper<DiscoveredEventsResponse>().map(JSONString: content)!
            getEvents = nuigJun16.data
        } catch {
            // stop the tests!
        }

        let events = getEvents!

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
        dateComponents.hour = 05

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
        dateComponents.hour = 13
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
}
