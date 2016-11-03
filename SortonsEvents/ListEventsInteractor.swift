//
//  EventsInteractor.swift
//  Sortons Events
//
//  Created by Brian Henry on 05/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import ObjectMapper

class ListEventsInteractor: NSObject, ListEventsTableViewControllerOutput {
    
    var allUpcomingEvents = [DiscoveredEvent]()
    
    let wireframe: ListEventsWireframe
    let fomoId: String
    let output: ListEventsInteractorOutput
    let listEventsNetworkWorker: ListEventsNetworkWorkerProtocol
    let listEventsCacheWorker: ListEventsCacheWorkerProtocol

    let observingFrom: Date!
    let dateFormat: DateFormatter
    let calendar: Calendar

    init(wireframe: ListEventsWireframe, fomoId: String, output: ListEventsInteractorOutput, listEventsNetworkWorker: ListEventsNetworkWorkerProtocol, listEventsCacheWorker: ListEventsCacheWorkerProtocol, withDate: Date = Date(), withCalendar: Calendar = Calendar.current){
        self.wireframe = wireframe
        self.fomoId = fomoId
        self.output = output
        self.listEventsNetworkWorker = listEventsNetworkWorker
        self.listEventsCacheWorker = listEventsCacheWorker
        
        observingFrom = withDate
        self.calendar = withCalendar
        dateFormat = DateFormatter()
        dateFormat.timeZone = calendar.timeZone
    }

    func fetchEvents(_ request: ListEvents_FetchEvents_Request) {
        
        // Get from cache
        let eventsFromCacheString = listEventsCacheWorker.fetch()
        if let eventsFromCacheString = eventsFromCacheString {
            let eventsFromCache: DiscoveredEventsResponse = Mapper<DiscoveredEventsResponse>().map(JSONString: eventsFromCacheString)!
            if let data = eventsFromCache.data {
                allUpcomingEvents = filterToOngoingEvents(data, observingFrom: observingFrom)
                let response = ListEvents_FetchEvents_Response(events: allUpcomingEvents)
                self.output.presentFetchedEvents(response)
            }
        }
        
        // Get from network
        listEventsNetworkWorker.fetchEvents(fomoId) { (discoveredEventsJsonPage) -> Void in
            
            // parse from json
            let discoveredEventsResponse: DiscoveredEventsResponse = Mapper<DiscoveredEventsResponse>().map(JSONString: discoveredEventsJsonPage)!
            
            if let data = discoveredEventsResponse.data {
                self.allUpcomingEvents = data
                
                // save to cache
                self.listEventsCacheWorker.save(discoveredEventsJsonPage)
                
                let response = ListEvents_FetchEvents_Response(events: self.allUpcomingEvents)
                self.output.presentFetchedEvents(response)
            }
        }
    }
    
    func displayEvent(for rowNumber: Int) {
        
        let fbId = allUpcomingEvents[rowNumber].eventId!
        
        let appUrl = URL(string: "fb://profile/\(fbId)")!
        let safariUrl = URL(string: "https://facebook.com/\(fbId)")!
        
        if UIApplication.shared.canOpenURL(appUrl) {
            UIApplication.shared.openURL(appUrl)
        } else {
            UIApplication.shared.openURL(safariUrl)
        }
    }
    
    // I think the latest FB API means all events have an end time TODO
    func filterToOngoingEvents(_ allEvents: [DiscoveredEvent], observingFrom: Date) -> [DiscoveredEvent] {
        
        let yesterday = calendar.date(byAdding: .day, value: -1, to: observingFrom)!
        let yesterday6pm = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: yesterday)!
        let today6am = calendar.date(bySettingHour: 6, minute: 0, second: 0, of: observingFrom)!
        
        var filteredEvents = [DiscoveredEvent]()
        
        // Events with a start or end time in the future
        let ongoingEvents = allEvents.filter(
            { ($0.endTime != nil && $0.endTime!.compare(observingFrom).rawValue > 0) || $0.startTime.compare(observingFrom).rawValue > 0 }
        )
        filteredEvents.append(contentsOf: ongoingEvents)
        
        // all day event today
        let todayAllDay = allEvents.filter({
            $0.dateOnly && calendar.isDate($0.startTime as Date, equalTo: observingFrom, toGranularity: .day)
        })
        filteredEvents.append(contentsOf: todayAllDay)
        
        // (no end time and start time today)
        let todayNoEnd = allEvents.filter({
            $0.endTime==nil && calendar.isDate($0.startTime as Date, equalTo: observingFrom, toGranularity: .day) && ($0.dateOnly == false)
        })
        filteredEvents.append(contentsOf: todayNoEnd)
        
        // if the current time is before 6am and the event started yesterday evening and had no end time
        let lastNight = allEvents.filter({
            observingFrom.compare(today6am).rawValue < 0 && (calendar as NSCalendar).isDate($0.startTime as Date, equalTo: yesterday, toUnitGranularity: .day) && $0.startTime.compare(yesterday6pm).rawValue > 0 && $0.endTime==nil
        })
        filteredEvents.append(contentsOf: lastNight)
        
        return filteredEvents
    }

    func changeToNextTabRight() {
        wireframe.changeToNextTabRight()
    }
}
