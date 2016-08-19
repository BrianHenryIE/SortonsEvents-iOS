//
//  ListEventsPresenter.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/07/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

class ListEventsPresenter : ListEventsInteractorOutput {
    
    let output : ListEventsPresenterOutput
    
    let observingFrom : NSDate!
    
    let dateFormat = NSDateFormatter()
    let calendar = NSCalendar.currentCalendar()
    
    // For testing
    init(output: ListEventsPresenterOutput, withDate: NSDate = NSDate()){
        self.output = output
        observingFrom = withDate
    }
    
    // Gotta set the view controller here... router?
    
    func presentFetchedEvents(upcomingEvents: ListEvents_FetchEvents_Response) {
    
        let filteredEvents = filterToOngoingEvents(upcomingEvents.events, observingFrom: observingFrom)
        
        // TODO This should maybe be outside this function. Currently untested
        let cellModels : [DiscoveredEventCellModel] = filteredEvents.map({
            let webUrl = NSURL(string: "https://facebook.com/events/\($0.eventId)/")!
            let appUrl = NSURL(string: "fb://profile/\($0.eventId)/")!
            let imageUrl = NSURL(string: "https://graph.facebook.com/\($0.eventId)@/picture?type=square")!
            
            return DiscoveredEventCellModel(webUrl: webUrl, appUrl: appUrl, name: $0.name, startTime: formatFriendlyTime($0.startTime, allDay: $0.dateOnly), location: $0.location, imageUrl: imageUrl)
        })
        
        let viewModel = ListEventsViewModel(discoveredEvents: cellModels)
        
        output.presentFetchedEvents(viewModel)
    }
    
    func filterToOngoingEvents(allEvents : [DiscoveredEvent], observingFrom: NSDate) -> [DiscoveredEvent] {
        
        let yesterday = calendar.dateByAddingUnit(.Day, value: -1, toDate: observingFrom, options: [])!
        let yesterday6pm = calendar.dateBySettingHour(18, minute: 0, second: 0, ofDate: yesterday, options: [])!
        let today6am = calendar.dateBySettingHour(6, minute: 0, second: 0, ofDate: observingFrom, options: NSCalendarOptions.MatchFirst)!
        
        var filteredEvents = [DiscoveredEvent]()
        
        // Events with a start or end time in the future
        let ongoingEvents = allEvents.filter(
            { ($0.endTime != nil && $0.endTime!.compare(observingFrom).rawValue > 0) || $0.startTime.compare(observingFrom).rawValue > 0 }
        )
        filteredEvents.appendContentsOf(ongoingEvents)
        
        // all day event today
        let todayAllDay = allEvents.filter({
             $0.dateOnly && calendar.isDate($0.startTime, equalToDate: observingFrom, toUnitGranularity: .Day)
            })
        filteredEvents.appendContentsOf(todayAllDay)
        
        // (no end time and start time today)
        let todayNoEnd = allEvents.filter({
                 $0.endTime==nil && calendar.isDate($0.startTime, equalToDate: observingFrom, toUnitGranularity: .Day) && ($0.dateOnly == false)
            })
        filteredEvents.appendContentsOf(todayNoEnd)
        
        // if the current time is before 6am and the event started yesterday evening and had no end time
        let lastNight = allEvents.filter({
            observingFrom.compare(today6am).rawValue < 0 && calendar.isDate($0.startTime, equalToDate: yesterday, toUnitGranularity: .Day) && $0.startTime.compare(yesterday6pm).rawValue > 0 && $0.endTime==nil
            })
        filteredEvents.appendContentsOf(lastNight)
    
        return filteredEvents
    }
    
    // Should really be an NSDate extension
    func formatFriendlyTime(date : NSDate, allDay : Bool, observingFrom : NSDate = NSDate()) -> String {
        
        let yesterday = calendar.dateByAddingUnit(.Day, value: -1, toDate: observingFrom, options: [])!
        let tomorrow = calendar.dateByAddingUnit(.Day, value: 1, toDate: observingFrom, options: [])!
        
        var format : String
        
        // if it's yesterday, today or tomorrow use the word
        if(calendar.isDate(date, equalToDate: yesterday, toUnitGranularity: .Day)) {
            format = "'Yesterday'"
        } else if(calendar.isDate(date, equalToDate: observingFrom, toUnitGranularity: .Day)) {
            format = "'Today'"
        } else if(calendar.isDate(date, equalToDate: tomorrow, toUnitGranularity: .Day)) {
            format = "'Tomorrow'"
        } else {
            format = "EEEE dd MMMM"
        }
        
        if(!allDay) {
            format = "\(format) 'at' HH:mm"
        }
        
        dateFormat.dateFormat = format
        
        return dateFormat.stringFromDate(date)
    }
}