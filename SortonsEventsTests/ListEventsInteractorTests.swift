//
//  EventsInteractorTests.swift
//  Sortons Events
//
//  Created by Brian Henry on 05/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest
import ObjectMapper
import Alamofire

fileprivate class EmptyNetworkSpy: ListEventsNetworkProtocol {

    var fetchEventsCalled = false

    func fetchEvents(_ fomoId: String, completionHandler: @escaping (_ result: Result<[DiscoveredEvent]>) -> Void) {

        fetchEventsCalled = true
        completionHandler(Result.success([DiscoveredEvent]()))
    }
}

fileprivate class EmptyCacheSpy<T: ImmutableMappable>: CacheProtocol {

    var fetchCalled = false

    func fetch<T: ImmutableMappable>() -> [T]? {
        fetchCalled = true
        return nil
    }

    var saveCalled = false

    func save<T: ImmutableMappable>(_ latestDiscoveredEvents: [T]?) {
        saveCalled = true
    }
}

fileprivate class NetworkSpy: ListEventsNetworkProtocol {

    // MARK: Method call expectations
    var fetchEventsCalled = false

    // MARK: Spied methods
    func fetchEvents(_ fomoId: String, completionHandler: @escaping (_ result: Result<[DiscoveredEvent]>) -> Void) {
        fetchEventsCalled = true

        // swiftlint:disable:next line_length
        let dataString = "[{\"eventId\": \"918777258231182\",\"clientId\": \"1049082365115363\",\"sourcePages\": [{\"clientId\": \"1049082365115363\",\"id\": \"1049082365115363457660710939203\",\"about\": \"NUI Galway's Student Volunteering Programme www.nuigalway.ie/alive\",\"name\": \"Alive Nuigalway\",\"pageId\": \"457660710939203\",\"pageUrl\": \"https://www.facebook.com/alive.nuigalway\",\"street\": \"\",\"zip\": \"\",\"uid\": \"457660710939203\",\"title\": \"Alive Nuigalway\",\"subTitle\": \"\",\"friendlyLocationString\": \"\",\"searchableString\": \"Alive Nuigalway null null Alive Nuigalway null \",\"class\": \"ie.sortons.events.shared.SourcePage\"}],\"name\": \"Information Evening for Volunteering with Galway's Community Bicycle Workshop\",\"location\": \"Block R, Earls Island, University Road, Galway.\",\"startTime\": \"2016-06-30T18:00:00.000Z\",\"endTime\": \"2016-06-30T19:00:00.000Z\",\"dateOnly\": false}]"

        if let dataObjects = try? Mapper<DiscoveredEvent>().mapArray(JSONString: dataString) {
            let result = Result<[DiscoveredEvent]>.success(dataObjects)
            completionHandler(result)
        }
    }
}

fileprivate class CacheSpy<T: ImmutableMappable>: CacheProtocol {

    var fetchCalled = false

    func fetch<T: ImmutableMappable>() -> [T]? {
        fetchCalled = true

        // swiftlint:disable:next line_length
        let dataString = "[{\"eventId\": \"918777258231182\",\"clientId\": \"1049082365115363\",\"sourcePages\": [{\"clientId\": \"1049082365115363\",\"id\": \"1049082365115363457660710939203\",\"about\": \"NUI Galway's Student Volunteering Programme www.nuigalway.ie/alive\",\"name\": \"Alive Nuigalway\",\"pageId\": \"457660710939203\",\"pageUrl\": \"https://www.facebook.com/alive.nuigalway\",\"street\": \"\",\"zip\": \"\",\"uid\": \"457660710939203\",\"title\": \"Alive Nuigalway\",\"subTitle\": \"\",\"friendlyLocationString\": \"\",\"searchableString\": \"Alive Nuigalway null null Alive Nuigalway null \",\"class\": \"ie.sortons.events.shared.SourcePage\"}],\"name\": \"Information Evening for Volunteering with Galway's Community Bicycle Workshop\",\"location\": \"Block R, Earls Island, University Road, Galway.\",\"startTime\": \"2016-06-30T18:00:00.000Z\",\"endTime\": \"2016-06-30T19:00:00.000Z\",\"dateOnly\": false}]"
        let dataObjects = try? Mapper<T>().mapArray(JSONString: dataString)
        return dataObjects
    }

    var saveCalled = false

    func save<T: ImmutableMappable>(_ latestClientPageData: [T]?) {
        saveCalled = true
    }
}

fileprivate class OutputSpy: ListEventsInteractorOutputProtocol {

    var presentFetchedEventsCalled = false

    func presentFetchedEvents(_ upcomingEvents: ListEvents.Fetch.Response) {
        presentFetchedEventsCalled = true
    }
}

class ListEventsInteractorTests: XCTestCase {

    let fomoId = FomoId(fomoIdNumber: "id",
                                name: "name",
                           shortName: "shortName",
                            longName: "longName",
                          appStoreId: "appStoreId",
                              censor: [String]())

    func testFetchEventsShouldAskEventsNetworkWorkerToFetchEventsAndPresenterToFormatResult() {
        let networkSpy = NetworkSpy()
        let cacheSpy = CacheSpy<DiscoveredEvent>()

        let interactorOutputSpy = OutputSpy()

        let sut = ListEventsInteractor(wireframe: ListEventsWireframe(fomoId: fomoId),
                                       fomoId: "",
                                       output: interactorOutputSpy,
                                       listEventsNetworkWorker: networkSpy,
                                       listEventsCacheWorker: cacheSpy)

        // When
        let request = ListEvents.Fetch.Request()
        sut.fetchEvents(request)

        // Then
        XCTAssert(cacheSpy.fetchCalled, "Fetch() should ask cacheWorker to fetch events")
        XCTAssert(networkSpy.fetchEventsCalled, "FetchEvents() should ask EventsNetworkWorker to fetch events")

        // This only gets called when there are events to return... test for both scenarios!
        XCTAssert(interactorOutputSpy.presentFetchedEventsCalled,
                  "FetchEvents() should ask presenter to format events result")
    }

    func testEmptyFetchEventsShouldNotHitPresenter() {
        let emptyNetworkSpy = EmptyNetworkSpy()
        let emptyCacheSpy = EmptyCacheSpy<DiscoveredEvent>()

        let interactorOutputSpy = OutputSpy()

        let sut = ListEventsInteractor(wireframe: ListEventsWireframe(fomoId: fomoId),
                                       fomoId: "",
                                       output: interactorOutputSpy,
                                       listEventsNetworkWorker: emptyNetworkSpy,
                                       listEventsCacheWorker: emptyCacheSpy)

        // When
        let request = ListEvents.Fetch.Request()
        sut.fetchEvents(request)

        // Then
        XCTAssert(emptyCacheSpy.fetchCalled, "Fetch() should ask cacheWorker to fetch events")
        XCTAssert(emptyNetworkSpy.fetchEventsCalled, "FetchEvents() should ask EventsNetworkWorker to fetch events")

        XCTAssertFalse(emptyCacheSpy.saveCalled,
                       "If the network worker was empty, no need to save to cache"
                        + "(or would overwrite a possibly valid cache)")

        XCTAssertFalse(interactorOutputSpy.presentFetchedEventsCalled,
                      "FetchEvents() should not ask presenter to format events result")
    }

    func testShouldDiscardEarlyEvents() {
        var remainingEvents: [DiscoveredEvent]
        var ourTime: Date
        var calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        calendar.timeZone = TimeZone(abbreviation: "UTC")!

        let interactorOutputSpy = OutputSpy()

        let wireframe = ListEventsWireframe(fomoId: fomoId)

        let sut = ListEventsInteractor(wireframe: wireframe,
                                       fomoId: "",
                                       output: interactorOutputSpy,
                                       listEventsNetworkWorker: EmptyNetworkSpy(),
                                       listEventsCacheWorker: CacheSpy<DiscoveredEvent>(),
                                       withDate: Date(),
                                       withCalendar: calendar)

        let content = readJsonFile(filename: "DiscoveredEventsResponseNUIG30June16")

        guard let nuigJun16 = try? Mapper<DiscoveredEventsResponse>().map(JSONString: content),
            let events = nuigJun16.data else {
            XCTFail("Error parsing test data")
                return
        }

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

        XCTAssertEqual(remainingEvents.count, 2,
                       "Event starting yesterday before 6pm with no end time should not be included")

        // If the event has no end time but started after 6pm, we don't remove it until 6am
        // The choice of nighttime cutoff is arbirtary
        // "startTime": "2016-07-23T19:00:00.000Z",
        dateComponents.day = 24
        dateComponents.hour = 02

        ourTime = calendar.date(from: dateComponents)!
        remainingEvents = sut.filterToOngoingEvents(events, observingFrom: ourTime)

        XCTAssertEqual(remainingEvents.count, 2,
                       "Event starting yesterday after 6pm with no end time should be included until 6am following")

        dateComponents.hour = 08

        ourTime = calendar.date(from: dateComponents)!
        remainingEvents = sut.filterToOngoingEvents(events, observingFrom: ourTime)

        XCTAssertEqual(remainingEvents.count, 1,
                       "Event starting yesteday after 6pm with no end time"
                        + "should not be included after 6am following")

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
