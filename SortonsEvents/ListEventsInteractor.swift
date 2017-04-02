//
//  EventsInteractor.swift
//  Sortons Events
//
//  Created by Brian Henry on 05/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import Alamofire

struct ListEvents {
    struct Fetch {
        struct Response {
            let events: [DiscoveredEvent]
            let source: Response.Source

            enum Source { case cache, network }
        }
    }
}

protocol ListEventsInteractorOutputProtocol {

    func presentFetchedEvents(_ upcomingEvents: ListEvents.Fetch.Response)

    func presentError(_ error: Error)
}

class ListEventsInteractor: NSObject, ListEventsTableViewControllerOutputProtocol {

    var allUpcomingEvents = [DiscoveredEvent]()

    let uiApplication: UIApplicationProtocol
    let wireframe: ListEventsWireframe
    let fomoId: String
    let output: ListEventsInteractorOutputProtocol
    let listEventsNetworkWorker: NetworkProtocol
    let cacheWorker: CacheProtocol

    let observingFrom: Date
    let dateFormat: DateFormatter
    let calendar: Calendar

    init(wireframe: ListEventsWireframe,
            fomoId: String,
            output: ListEventsInteractorOutputProtocol,
         listEventsNetworkWorker: NetworkProtocol,
           listEventsCacheWorker: CacheProtocol,
                        withDate: Date = Date(),
                    withCalendar: Calendar = Calendar.current,
                   uiApplication: UIApplicationProtocol = UIApplication.shared) {
        self.wireframe = wireframe
        self.fomoId = fomoId
        self.output = output
        self.listEventsNetworkWorker = listEventsNetworkWorker
        self.cacheWorker = listEventsCacheWorker
        self.uiApplication = uiApplication

        observingFrom = withDate
        self.calendar = withCalendar
        dateFormat = DateFormatter()
        dateFormat.timeZone = calendar.timeZone
    }

    func fetchFromCache() {
        if let eventsFromCache: [DiscoveredEvent] = cacheWorker.fetch() {
            allUpcomingEvents = filterToOngoingEvents(eventsFromCache, observingFrom: observingFrom)
            let response = ListEvents.Fetch.Response(events: allUpcomingEvents, source: .cache)
            output.presentFetchedEvents(response)
        }
    }

    func fetchFromNetwork() {

        listEventsNetworkWorker.fetch(fomoId) { (response: Result<[DiscoveredEvent]>) -> Void in

            switch response {
            case .success(let networkData):

                let allUpcomingEvents = self.filterToOngoingEvents(networkData)

                if allUpcomingEvents.count > 0 {
                    self.cacheWorker.save(allUpcomingEvents)
                }

                let response = ListEvents.Fetch.Response(events: allUpcomingEvents,
                                                         source: .network)

                self.output.presentFetchedEvents(response)

                break

            case .failure(let error):

                self.output.presentError(error)

                break
            }
        }
    }

    func displayEvent(for rowNumber: Int) {

        let fbId = allUpcomingEvents[rowNumber].eventId

        guard let appUrl = URL(string: "fb://profile/\(fbId)"),
            let safariUrl = URL(string: "https://facebook.com/\(fbId)") else {
            return
        }

        if uiApplication.canOpenURL(appUrl) {
            uiApplication.open(appUrl, options: [:], completionHandler: nil)
        } else {
            uiApplication.open(safariUrl, options: [:], completionHandler: nil)
        }
    }

    func filterToOngoingEvents(_ allEvents: [DiscoveredEvent], observingFrom: Date = Date()) -> [DiscoveredEvent] {

        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: observingFrom),
            let yesterday6pm = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: yesterday),
            let today6am = calendar.date(bySettingHour: 6, minute: 0, second: 0, of: observingFrom) else {
                return allEvents
        }

        var filteredEvents = [DiscoveredEvent]()

        // Events with a start or end time in the future
        let ongoingEvents = allEvents.filter({
            if let endTime = $0.endTime, endTime.compare(observingFrom).rawValue > 0 {
                return true
            }
            if $0.startTime.compare(observingFrom).rawValue > 0 {
                return true
            }
            return false
        })
        filteredEvents.append(contentsOf: ongoingEvents)

        // all day event today
        let todayAllDay = allEvents.filter({
            if $0.dateOnly,
                calendar.isDate($0.startTime, equalTo: observingFrom, toGranularity: .day) {
                return true
            }
            return false
        })
        filteredEvents.append(contentsOf: todayAllDay)

        // (no end time and start time today)
        let todayNoEnd = allEvents.filter({
            $0.endTime==nil
                && calendar.isDate($0.startTime as Date, equalTo: observingFrom, toGranularity: .day)
                && ($0.dateOnly == false)
        })
        filteredEvents.append(contentsOf: todayNoEnd)

        // if the current time is before 6am and the event started yesterday evening and had no end time
        let lastNight = allEvents.filter({
            observingFrom.compare(today6am).rawValue < 0
                && (calendar as NSCalendar).isDate($0.startTime as Date, equalTo: yesterday, toUnitGranularity: .day)
                && $0.startTime.compare(yesterday6pm).rawValue > 0
                && $0.endTime==nil
        })
        filteredEvents.append(contentsOf: lastNight)

        return filteredEvents
    }
}
