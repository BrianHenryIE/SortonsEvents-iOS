//
//  ListEventsPresenter.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/07/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

protocol ListEventsPresenterOutputProtocol {
    func presentFetchedEvents(_ viewModel: ListEvents.ViewModel)

    func displayFetchEventsFetchError(_ viewModel: ListEvents.ViewModel)
}

extension ListEvents {
    struct ViewModel {
        struct Cell {
            let name: String
            let startTime: String
            let location: String?
            let imageUrl: URL?
        }

        let discoveredEvents: [Cell]
        let hideRefreshControl: Bool
    }
}

class ListEventsPresenter: ListEventsInteractorOutputProtocol {

    let output: ListEventsPresenterOutputProtocol?
    let calendar: Calendar

    // For testing
    init(output: ListEventsPresenterOutputProtocol?, calendar: Calendar = Calendar.current) {
        self.output = output
        self.calendar = calendar
    }

    func presentFetchedEvents(_ upcomingEvents: ListEvents.Fetch.Response) {

        let cells: [ListEvents.ViewModel.Cell] = upcomingEvents.events.map({
                let imageUrl = URL(string: "https://graph.facebook.com/\($0.eventId)/picture?type=square")

                return ListEvents.ViewModel.Cell(name: $0.name,
                                            startTime: formatFriendlyTime($0.startTime, allDay: $0.dateOnly),
                                             location: $0.location,
                                             imageUrl: imageUrl)
        })

        let hideRefreshContol: Bool
        switch upcomingEvents.source {
        case .cache:
            hideRefreshContol = false
        case .network:
            hideRefreshContol = true
        }

        let viewData = ListEvents.ViewModel(discoveredEvents: cells,
                                          hideRefreshControl: hideRefreshContol)

        DispatchQueue.main.async {
            self.output?.presentFetchedEvents(viewData)
        }
    }

    func formatFriendlyTime(_ date: Date, allDay: Bool, observingFrom: Date = Date()) -> String {

        let dateFormat = DateFormatter()
        dateFormat.timeZone = calendar.timeZone

        let yesterday = calendar.date(byAdding: .day, value: -1, to: observingFrom)!
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: observingFrom)!

        var format: String

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

        if !allDay {
            format = "\(format) 'at' HH:mm"
        }

        dateFormat.dateFormat = format

        return dateFormat.string(from: date)
    }
}
