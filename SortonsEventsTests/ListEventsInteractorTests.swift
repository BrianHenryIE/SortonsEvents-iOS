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

private class EmptyNetworkSpy: NetworkProtocol {

    var fetchCalled = false

    func fetch<T: SortonsNW & ImmutableMappable>
        (_ fomoId: String,
         completionHandler: @escaping (_ result: Result<[T]>) -> Void) {

        fetchCalled = true
        completionHandler(Result.success([T]()))
    }
}

private class EmptyCacheSpy<T: ImmutableMappable>: CacheProtocol {

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

private class NetworkSpy: NetworkProtocol {

    var fetchEventsCalled = false

    func fetch<T: SortonsNW & ImmutableMappable>(_ fomoId: String,
               completionHandler: @escaping (_ result: Result<[T]>) -> Void) {
        fetchEventsCalled = true

        // swiftlint:disable:next line_length
        let dataString = "[{\"eventId\": \"918777258231182\",\"clientId\": \"1049082365115363\",\"sourcePages\": [{\"clientId\": \"1049082365115363\",\"id\": \"1049082365115363457660710939203\",\"about\": \"NUI Galway's Student Volunteering Programme www.nuigalway.ie/alive\",\"name\": \"Alive Nuigalway\",\"pageId\": \"457660710939203\",\"pageUrl\": \"https://www.facebook.com/alive.nuigalway\",\"street\": \"\",\"zip\": \"\",\"uid\": \"457660710939203\",\"title\": \"Alive Nuigalway\",\"subTitle\": \"\",\"friendlyLocationString\": \"\",\"searchableString\": \"Alive Nuigalway null null Alive Nuigalway null \",\"class\": \"ie.sortons.events.shared.SourcePage\"}],\"name\": \"Information Evening for Volunteering with Galway's Community Bicycle Workshop\",\"location\": \"Block R, Earls Island, University Road, Galway.\",\"startTime\": \"2016-06-30T18:00:00.000Z\",\"endTime\": \"2016-06-30T19:00:00.000Z\",\"dateOnly\": false}]"

        if let dataObjects = try? Mapper<T>().mapArray(JSONString: dataString) {
            let result = Result<[T]>.success(dataObjects)
            completionHandler(result)
        }
    }
}

private class NetworkErrorMock: NetworkProtocol {

    var fetchEventsCalled = false

    func fetch<T: SortonsNW & ImmutableMappable>(_ fomoId: String,
                                                 completionHandler: @escaping (_ result: Result<[T]>) -> Void) {
        fetchEventsCalled = true

        let result = Result<[T]>.failure(NSError())
        completionHandler(result)

    }
}

private class CacheSpy<T: ImmutableMappable>: CacheProtocol {

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

private class OutputSpy: ListEventsInteractorOutputProtocol {

    var presentFetchedEventsCalled = false
    var presentErrorHit = false

    func presentFetchedEvents(_ upcomingEvents: ListEvents.Fetch.Response) {
        presentFetchedEventsCalled = true
    }

    func presentError(_ error: Error) {
        presentErrorHit = true
    }
}

private class UIApplicationMock: UIApplicationProtocol {

    var canOpenURLHit = false
    var returnCanOpenURL = true

    var openHit = false
    var urlUsed: URL!

    func canOpenURL(_ url: URL) -> Bool {
        canOpenURLHit = true
        return returnCanOpenURL
    }

    func open(_ url: URL,
              options: [String : Any],
              completionHandler completion: ((Bool) -> Void)?) {
        urlUsed = url
        openHit = true
    }
}

class ListEventsInteractorTests: XCTestCase {

    var interactor: ListEventsInteractor!
    private var networkSpy: NetworkSpy!
    private var cacheSpy: CacheSpy<DiscoveredEvent>!
    private var output: ListEventsInteractorOutputProtocol!
    private var uiApplication: UIApplicationMock!

    let fomoId = FomoId(fomoIdNumber: "id",
                                name: "name",
                           shortName: "shortName",
                            longName: "longName",
                          appStoreId: "appStoreId",
                              censor: [String]())

    override func setUp() {
        super.setUp()

        networkSpy = NetworkSpy()
        cacheSpy = CacheSpy<DiscoveredEvent>()

        output = OutputSpy()

        uiApplication = UIApplicationMock()

        interactor = ListEventsInteractor(wireframe: ListEventsWireframe(fomoId: fomoId),
                                       fomoId: "",
                                       output: output,
                                       listEventsNetworkWorker: networkSpy,
                                       listEventsCacheWorker: cacheSpy,
                                       uiApplication: uiApplication)

        let dataString = readJsonFile(filename: "ListEventsInteractorTestsData")

        let dataObjects = try? Mapper<DiscoveredEvent>().mapArray(JSONString: dataString)

        interactor.allUpcomingEvents = dataObjects!
    }

    func testFetchFromCacheShouldAskCacheWorkerForEventsAndPresenterToFormatResult() {

        interactor.fetchFromCache()

        // Then
        XCTAssert(cacheSpy.fetchCalled, "Fetch() should ask cacheWorker to fetch events")

        // This only gets called when there are events to return... test for both scenarios!
        // XCTAssert(interactorOutputSpy.presentFetchedEventsCalled,
           //       "FetchEvents() should ask presenter to format events result")
    }

    func testFetchFromNetworkHitsNetwork() {
        let networkSpy = NetworkSpy()
        let cacheSpy = CacheSpy<DiscoveredEvent>()

        let interactorOutputSpy = OutputSpy()

        let viewController = ListEventsInteractor(wireframe: ListEventsWireframe(fomoId: fomoId),
                                       fomoId: "",
                                       output: interactorOutputSpy,
                                       listEventsNetworkWorker: networkSpy,
                                       listEventsCacheWorker: cacheSpy)

        viewController.fetchFromNetwork()

        XCTAssertFalse(cacheSpy.fetchCalled)
        XCTAssertTrue(networkSpy.fetchEventsCalled)
    }

    func testShouldPresentError() {

        let networkErrorMock = NetworkErrorMock()
        let cacheSpy = CacheSpy<DiscoveredEvent>()
        let interactorOutputSpy = OutputSpy()

        let viewController = ListEventsInteractor(wireframe: ListEventsWireframe(fomoId: fomoId),
                                                  fomoId: "",
                                                  output: interactorOutputSpy,
                                                  listEventsNetworkWorker: networkErrorMock,
                                                  listEventsCacheWorker: cacheSpy)

        viewController.fetchFromNetwork()

        XCTAssert(interactorOutputSpy.presentErrorHit)
    }

    func testDisplayEventWithFbApp() {

        uiApplication.returnCanOpenURL = true

        let row = 1
        interactor.displayEvent(for: row)

        XCTAssertTrue(uiApplication.canOpenURLHit)

        XCTAssertTrue(uiApplication.openHit)

        XCTAssertTrue(uiApplication.urlUsed.absoluteString.hasPrefix("fb:"))
    }

    func testDisplayEventWithoutFbApp() {

        uiApplication.returnCanOpenURL = false

        let row = 1
        interactor.displayEvent(for: row)

        XCTAssertTrue(uiApplication.canOpenURLHit)

        XCTAssertTrue(uiApplication.openHit)

        XCTAssertTrue(uiApplication.urlUsed.absoluteString.hasPrefix("https:"))
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
