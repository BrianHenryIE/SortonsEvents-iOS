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
    
    let observingFrom : Date!
    
    let dateFormat : DateFormatter
    let calendar : Calendar
    
    // For testing
    init(output: ListEventsPresenterOutput, withDate: Date = Date(), withCalendar: Calendar = Calendar.current){
        self.output = output
        observingFrom = withDate
        self.calendar = withCalendar
        dateFormat = DateFormatter()
        dateFormat.timeZone = calendar.timeZone
    }
    
    // Gotta set the view controller here... router?
    
    func presentFetchedEvents(_ upcomingEvents: ListEvents_FetchEvents_Response) {
    
        let filteredEvents = filterToOngoingEvents(upcomingEvents.events, observingFrom: observingFrom)
        
        if(!filteredEvents.isEmpty){
            
            // TODO This should maybe be outside this function. Currently test failing here!
            let cellModels : [DiscoveredEventCellModel] = filteredEvents.map({
                let webUrl = URL(string: "https://facebook.com/events/\($0.eventId!)/")!
                let appUrl = URL(string: "fb://profile/\($0.eventId!)/")!
                let imageUrl = URL(string: "https://graph.facebook.com/\($0.eventId!)@/picture?type=square")!
                
                return DiscoveredEventCellModel(webUrl: webUrl, appUrl: appUrl, name: $0.name, startTime: formatFriendlyTime($0.startTime, allDay: $0.dateOnly), location: $0.location, imageUrl: imageUrl)
            })
            
            let viewModel = ListEventsViewModel(discoveredEvents: cellModels)
            
            output.presentFetchedEvents(viewModel)
        }
    }
    
    func filterToOngoingEvents(_ allEvents : [DiscoveredEvent], observingFrom: Date) -> [DiscoveredEvent] {
        
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
             $0.dateOnly && (calendar as Calendar).isDate($0.startTime as Date, equalTo: observingFrom, toGranularity: .day)
            })
        filteredEvents.append(contentsOf: todayAllDay)
        
        // (no end time and start time today)
        let todayNoEnd = allEvents.filter({
                 $0.endTime==nil && (calendar as Calendar).isDate($0.startTime as Date, equalTo: observingFrom, toGranularity: .day) && ($0.dateOnly == false)
            })
        filteredEvents.append(contentsOf: todayNoEnd)
        
        // if the current time is before 6am and the event started yesterday evening and had no end time
        let lastNight = allEvents.filter({
            observingFrom.compare(today6am).rawValue < 0 && (calendar as NSCalendar).isDate($0.startTime as Date, equalTo: yesterday, toUnitGranularity: .day) && $0.startTime.compare(yesterday6pm).rawValue > 0 && $0.endTime==nil
            })
        filteredEvents.append(contentsOf: lastNight)
    
        return filteredEvents
    }
    
    // Should really be an NSDate extension
    func formatFriendlyTime(_ date : Date, allDay : Bool, observingFrom : Date = Date()) -> String {
        
        let yesterday = calendar.date(byAdding: .day, value: -1, to: observingFrom)!
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: observingFrom)!
        
        var format : String
        
        // if it's yesterday, today or tomorrow use the word
        if(calendar.isDate(date, equalTo: yesterday, toGranularity: .day)) {
            format = "'Yesterday'"
        } else if(calendar.isDate(date, equalTo: observingFrom, toGranularity: .day)) {
            format = "'Today'"
        } else if(calendar.isDate(date, equalTo: tomorrow, toGranularity: .day)) {
            format = "'Tomorrow'"
        } else {
            format = "EEEE dd MMMM"
        }
        
        if(!allDay) {
            format = "\(format) 'at' HH:mm"
        }
        
        dateFormat.dateFormat = format
        
        return dateFormat.string(from: date)
    }
}
