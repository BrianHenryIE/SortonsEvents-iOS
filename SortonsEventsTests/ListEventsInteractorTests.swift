//
//  EventsInteractorTests.swift
//  Sortons Events
//
//  Created by Brian Henry on 05/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import XCTest
@testable import SortonsEvents

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
    
    func fetch(_ completionHandler: (_ discoveredEvents: String) -> Void) {
        fetchCalled = true
        completionHandler("{}") // should I bother?
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
    
    func fetch(_ completionHandler: (_ discoveredEvents: String) -> Void) {
        fetchCalled = true
        completionHandler("{\"data\": [{\"eventId\": \"918777258231182\",\"clientId\": \"1049082365115363\",\"sourcePages\": [{\"clientId\": \"1049082365115363\",\"id\": \"1049082365115363457660710939203\",\"about\": \"NUI Galway's Student Volunteering Programme www.nuigalway.ie/alive\",\"name\": \"Alive Nuigalway\",\"pageId\": \"457660710939203\",\"pageUrl\": \"https://www.facebook.com/alive.nuigalway\",\"street\": \"\",\"zip\": \"\",\"uid\": \"457660710939203\",\"title\": \"Alive Nuigalway\",\"subTitle\": \"\",\"friendlyLocationString\": \"\",\"searchableString\": \"Alive Nuigalway null null Alive Nuigalway null \",\"class\": \"ie.sortons.events.shared.SourcePage\"}],\"name\": \"Information Evening for Volunteering with Galway's Community Bicycle Workshop\",\"location\": \"Block R, Earls Island, University Road, Galway.\",\"startTime\": \"2016-06-30T18:00:00.000Z\",\"endTime\": \"2016-06-30T19:00:00.000Z\",\"dateOnly\": false}]}") // should I bother?
    }
    
    var saveCalled = false
    
    func save(_ latestDiscoveredEvents: String) {
        saveCalled = true
    }
}

class ListEventsInteractorOutputSpy: ListEventsInteractorOutput {
    
    var presentFetchedEventsCalled = false
    
    func presentFetchedEvents(_ upcomingEvents: ListEvents_FetchEvents_Response) {
        presentFetchedEventsCalled = true
    }
}

class ListEventsInteractorTests: XCTestCase {
    
    func testFetchEventsShouldAskEventsNetworkWorkerToFetchEventsAndPresenterToFormatResult() {
        let listEventsNetworkWorkerSpy = ListEventsNetworkWorkerSpy()
        let listEventsCacheWorkerSpy = ListEventsCacheWorkerSpy()
   
        let listEventsInteractorOutputSpy = ListEventsInteractorOutputSpy()
        
        let sut = ListEventsInteractor(fomoId: "", output: listEventsInteractorOutputSpy, listEventsNetworkWorker: listEventsNetworkWorkerSpy, listEventsCacheWorker: listEventsCacheWorkerSpy)
        
        // When
        let request = ListEvents_FetchEvents_Request()
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
        
        let sut = ListEventsInteractor(fomoId: "", output: listEventsInteractorOutputSpy, listEventsNetworkWorker: emptyListEventsNetworkWorkerSpy, listEventsCacheWorker: emptyListEventsCacheWorkerSpy)
        
        // When
        let request = ListEvents_FetchEvents_Request()
        sut.fetchEvents(request)
        
        // Then
        XCTAssert(emptyListEventsCacheWorkerSpy.fetchCalled, "Fetch() should ask ListEventsCacheWorker to fetch events")
        XCTAssert(emptyListEventsNetworkWorkerSpy.fetchEventsCalled, "FetchEvents() should ask EventsNetworkWorker to fetch events")
        
        XCTAssert(!emptyListEventsCacheWorkerSpy.saveCalled, "If the network worker was empty, no need to save to cache (or would overwrite a possibly valid cache)")
        
        XCTAssert(!listEventsInteractorOutputSpy.presentFetchedEventsCalled, "FetchEvents() should not ask presenter to format events result")
    }
}
